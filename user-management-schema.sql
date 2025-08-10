-- User Management and Role-Based Access Control Schema
-- Run this in your Supabase SQL Editor

-- 1. Create user_roles table
CREATE TABLE IF NOT EXISTS user_roles (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    role_name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    permissions JSONB DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Create system_users table (extends Supabase auth.users)
CREATE TABLE IF NOT EXISTS system_users (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    auth_user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    email VARCHAR(255) NOT NULL UNIQUE,
    full_name VARCHAR(255) NOT NULL,
    role_id UUID REFERENCES user_roles(id) NOT NULL,
    council_id UUID REFERENCES councils(id), -- NULL for admin/national users
    phone VARCHAR(20),
    is_active BOOLEAN DEFAULT TRUE,
    last_login TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    created_by UUID REFERENCES system_users(id)
);

-- 3. Create project_validations table for supervisor validation
CREATE TABLE IF NOT EXISTS project_validations (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    project_id UUID REFERENCES projects(id) ON DELETE CASCADE,
    update_type VARCHAR(50) NOT NULL, -- 'status_change', 'milestone_update', 'document_upload', etc.
    update_data JSONB NOT NULL,
    requested_by UUID REFERENCES system_users(id) NOT NULL,
    validator_id UUID REFERENCES system_users(id),
    validation_status VARCHAR(20) DEFAULT 'pending', -- pending, approved, rejected
    validation_notes TEXT,
    requested_at TIMESTAMPTZ DEFAULT NOW(),
    validated_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 4. Create project_milestones table
CREATE TABLE IF NOT EXISTS project_milestones (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    project_id UUID REFERENCES projects(id) ON DELETE CASCADE,
    milestone_name VARCHAR(255) NOT NULL,
    description TEXT,
    target_date DATE,
    actual_date DATE,
    status VARCHAR(20) DEFAULT 'pending', -- pending, in_progress, completed, delayed
    completion_percentage DECIMAL(5,2) DEFAULT 0,
    supporting_documents JSONB DEFAULT '[]',
    created_by UUID REFERENCES system_users(id),
    validated_by UUID REFERENCES system_users(id),
    validation_status VARCHAR(20) DEFAULT 'pending',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 5. Create project_documents table for file management
CREATE TABLE IF NOT EXISTS project_documents (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    project_id UUID REFERENCES projects(id) ON DELETE CASCADE,
    milestone_id UUID REFERENCES project_milestones(id) ON DELETE SET NULL,
    document_name VARCHAR(255) NOT NULL,
    document_type VARCHAR(50), -- 'report', 'invoice', 'photo', 'contract', etc.
    file_path TEXT NOT NULL,
    file_size BIGINT,
    mime_type VARCHAR(100),
    uploaded_by UUID REFERENCES system_users(id),
    validation_status VARCHAR(20) DEFAULT 'pending',
    validated_by UUID REFERENCES system_users(id),
    validation_notes TEXT,
    is_public BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 6. Create audit_logs table for tracking all changes
CREATE TABLE IF NOT EXISTS audit_logs (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES system_users(id),
    action VARCHAR(100) NOT NULL,
    table_name VARCHAR(50),
    record_id UUID,
    old_data JSONB,
    new_data JSONB,
    ip_address INET,
    user_agent TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Insert default user roles
INSERT INTO user_roles (role_name, description, permissions) VALUES
('admin', 'Administrator/National Coordinator with full access', '{
    "users": ["create", "read", "update", "delete"],
    "councils": ["create", "read", "update", "delete"],
    "projects": ["create", "read", "update", "delete"],
    "kpis": ["create", "read", "update", "delete"],
    "validations": ["read", "approve", "reject"],
    "documents": ["create", "read", "update", "delete"],
    "milestones": ["create", "read", "update", "delete"],
    "reports": ["read", "export"],
    "audit_logs": ["read"]
}'),
('council_user', 'Council User with council-specific access', '{
    "projects": ["read", "update_own_council"],
    "kpis": ["read", "update_own_council"],
    "milestones": ["create", "read", "update_own_council"],
    "documents": ["create", "read", "update_own_council"],
    "validations": ["create"],
    "reports": ["read_own_council"]
}'),
('supervisor', 'Supervisor/Judge to validate updates', '{
    "projects": ["read"],
    "kpis": ["read"],
    "milestones": ["read"],
    "documents": ["read"],
    "validations": ["read", "approve", "reject"],
    "reports": ["read"]
}'),
('auditor', 'Auditor with read-only access', '{
    "projects": ["read"],
    "kpis": ["read"],
    "milestones": ["read"],
    "documents": ["read"],
    "validations": ["read"],
    "reports": ["read", "export"],
    "audit_logs": ["read"]
}')
ON CONFLICT (role_name) DO NOTHING;

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_system_users_role_id ON system_users(role_id);
CREATE INDEX IF NOT EXISTS idx_system_users_council_id ON system_users(council_id);
CREATE INDEX IF NOT EXISTS idx_project_validations_project_id ON project_validations(project_id);
CREATE INDEX IF NOT EXISTS idx_project_validations_status ON project_validations(validation_status);
CREATE INDEX IF NOT EXISTS idx_project_milestones_project_id ON project_milestones(project_id);
CREATE INDEX IF NOT EXISTS idx_project_documents_project_id ON project_documents(project_id);
CREATE INDEX IF NOT EXISTS idx_audit_logs_user_id ON audit_logs(user_id);
CREATE INDEX IF NOT EXISTS idx_audit_logs_created_at ON audit_logs(created_at);

-- Add update triggers
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_system_users_updated_at BEFORE UPDATE ON system_users FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_project_milestones_updated_at BEFORE UPDATE ON project_milestones FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_project_documents_updated_at BEFORE UPDATE ON project_documents FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- RLS Policies (disable for now for simplicity, enable in production)
ALTER TABLE user_roles DISABLE ROW LEVEL SECURITY;
ALTER TABLE system_users DISABLE ROW LEVEL SECURITY;
ALTER TABLE project_validations DISABLE ROW LEVEL SECURITY;
ALTER TABLE project_milestones DISABLE ROW LEVEL SECURITY;
ALTER TABLE project_documents DISABLE ROW LEVEL SECURITY;
ALTER TABLE audit_logs DISABLE ROW LEVEL SECURITY;

-- Create a function to log audit events
CREATE OR REPLACE FUNCTION log_audit_event(
    p_user_id UUID,
    p_action VARCHAR(100),
    p_table_name VARCHAR(50),
    p_record_id UUID DEFAULT NULL,
    p_old_data JSONB DEFAULT NULL,
    p_new_data JSONB DEFAULT NULL
)
RETURNS VOID AS $$
BEGIN
    INSERT INTO audit_logs (user_id, action, table_name, record_id, old_data, new_data)
    VALUES (p_user_id, p_action, p_table_name, p_record_id, p_old_data, p_new_data);
END;
$$ LANGUAGE plpgsql;

-- Sample data for testing (you can remove this in production)
-- Note: You'll need to create actual auth.users first via Supabase Auth, then link them here
/*
INSERT INTO system_users (email, full_name, role_id, council_id) VALUES
('admin@ppms.gov.sl', 'System Administrator', (SELECT id FROM user_roles WHERE role_name = 'admin'), NULL),
('freetown@ppms.gov.sl', 'Freetown Council User', (SELECT id FROM user_roles WHERE role_name = 'council_user'), (SELECT id FROM councils WHERE name LIKE 'Freetown%' LIMIT 1)),
('supervisor@ppms.gov.sl', 'Project Supervisor', (SELECT id FROM user_roles WHERE role_name = 'supervisor'), NULL),
('auditor@ppms.gov.sl', 'System Auditor', (SELECT id FROM user_roles WHERE role_name = 'auditor'), NULL);
*/

COMMENT ON TABLE user_roles IS 'Defines system roles and their permissions';
COMMENT ON TABLE system_users IS 'System users with role-based access control';
COMMENT ON TABLE project_validations IS 'Tracks validation requests for project updates';
COMMENT ON TABLE project_milestones IS 'Project milestones with validation workflow';
COMMENT ON TABLE project_documents IS 'Project documents with validation and access control';
COMMENT ON TABLE audit_logs IS 'Comprehensive audit trail for all system actions';
