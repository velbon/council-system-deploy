-- Enhanced schema for admin features and KPI tracking
-- Run these commands in your Supabase SQL Editor

-- 1. Add KPIs table for project assessment
CREATE TABLE IF NOT EXISTS kpis (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  project_id UUID NOT NULL,
  kpi_name TEXT NOT NULL,
  kpi_description TEXT,
  target_value DECIMAL(10,2),
  current_value DECIMAL(10,2) DEFAULT 0,
  unit TEXT, -- e.g., '%', 'days', 'count', '$'
  measurement_date DATE DEFAULT CURRENT_DATE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  
  CONSTRAINT fk_kpis_project_id 
    FOREIGN KEY (project_id) 
    REFERENCES projects(id) 
    ON DELETE CASCADE
);

-- 2. Add admin_users table for role management
CREATE TABLE IF NOT EXISTS admin_users (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  role TEXT DEFAULT 'admin' CHECK (role IN ('admin', 'super_admin', 'viewer')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  is_active BOOLEAN DEFAULT true
);

-- 3. Enhance projects table with additional fields
ALTER TABLE projects 
ADD COLUMN IF NOT EXISTS description TEXT,
ADD COLUMN IF NOT EXISTS priority TEXT DEFAULT 'medium' CHECK (priority IN ('low', 'medium', 'high', 'critical')),
ADD COLUMN IF NOT EXISTS completion_percentage DECIMAL(5,2) DEFAULT 0,
ADD COLUMN IF NOT EXISTS risk_level TEXT DEFAULT 'low' CHECK (risk_level IN ('low', 'medium', 'high')),
ADD COLUMN IF NOT EXISTS project_manager TEXT,
ADD COLUMN IF NOT EXISTS estimated_duration_days INTEGER,
ADD COLUMN IF NOT EXISTS actual_duration_days INTEGER;

-- 4. Create project_kpi_templates for common KPIs
CREATE TABLE IF NOT EXISTS project_kpi_templates (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  template_name TEXT NOT NULL,
  kpi_name TEXT NOT NULL,
  kpi_description TEXT,
  default_target DECIMAL(10,2),
  unit TEXT,
  category TEXT, -- 'financial', 'timeline', 'quality', 'performance'
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 5. Insert common KPI templates
INSERT INTO project_kpi_templates (template_name, kpi_name, kpi_description, default_target, unit, category) VALUES
('Infrastructure', 'Budget Utilization', 'Percentage of budget used', 95.00, '%', 'financial'),
('Infrastructure', 'Timeline Adherence', 'On-time completion rate', 90.00, '%', 'timeline'),
('Infrastructure', 'Quality Score', 'Project quality assessment', 85.00, '%', 'quality'),
('Infrastructure', 'Safety Incidents', 'Number of safety incidents', 0.00, 'count', 'performance'),
('Community', 'Community Engagement', 'Citizen participation rate', 70.00, '%', 'performance'),
('Community', 'Satisfaction Rating', 'Community satisfaction score', 80.00, '%', 'quality'),
('Community', 'Service Coverage', 'Population coverage percentage', 85.00, '%', 'performance'),
('Economic', 'Job Creation', 'Number of jobs created', 50.00, 'count', 'performance'),
('Economic', 'ROI', 'Return on investment', 15.00, '%', 'financial'),
('Environmental', 'Carbon Reduction', 'CO2 emissions reduced', 20.00, '%', 'performance'),
('Environmental', 'Waste Reduction', 'Waste reduction percentage', 30.00, '%', 'performance')
ON CONFLICT DO NOTHING;

-- 6. Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_kpis_project_id ON kpis(project_id);
CREATE INDEX IF NOT EXISTS idx_kpis_measurement_date ON kpis(measurement_date DESC);
CREATE INDEX IF NOT EXISTS idx_admin_users_email ON admin_users(email);
CREATE INDEX IF NOT EXISTS idx_projects_priority ON projects(priority);
CREATE INDEX IF NOT EXISTS idx_projects_completion ON projects(completion_percentage);

-- 7. Create updated_at trigger for KPIs
CREATE OR REPLACE FUNCTION update_kpis_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_kpis_updated_at
  BEFORE UPDATE ON kpis
  FOR EACH ROW
  EXECUTE FUNCTION update_kpis_updated_at();

-- 8. Disable RLS for new tables (keeping it simple for admin features)
ALTER TABLE kpis DISABLE ROW LEVEL SECURITY;
ALTER TABLE admin_users DISABLE ROW LEVEL SECURITY;
ALTER TABLE project_kpi_templates DISABLE ROW LEVEL SECURITY;

-- 9. Insert a default admin user (replace with your email)
INSERT INTO admin_users (email, role) 
VALUES ('admin@ppms.local', 'super_admin') 
ON CONFLICT (email) DO NOTHING;

SELECT 'Admin schema setup complete!' as status;
