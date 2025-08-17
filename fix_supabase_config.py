#!/usr/bin/env python3
"""
Fix Supabase Configuration Script
Helps resolve site URL and missing user record issues
"""

import json

def main():
    print("🔧 PPMS Supabase Configuration Fix")
    print("=" * 50)
    print()
    
    print("Issues identified:")
    print("1. ❌ Site URL configured for localhost instead of production")
    print("2. ❌ User created in auth but missing from system_users table")
    print()
    
    print("FIXES NEEDED:")
    print()
    
    print("1. 🌐 UPDATE SUPABASE SITE URL:")
    print("   → Go to: https://app.supabase.com/project/lschntjazpnyljuauyuy/auth/url-configuration")
    print("   → Change 'Site URL' from: http://localhost:3000")
    print("   → Change 'Site URL' to: https://council-system-deploy.onrender.com")
    print("   → Save changes")
    print()
    
    print("2. 📊 CREATE MISSING DATABASE TABLES:")
    print("   Run these SQL commands in Supabase SQL Editor:")
    print("   → Go to: https://app.supabase.com/project/lschntjazpnyljuauyuy/sql")
    print()
    
    # SQL Commands to create missing tables and data
    sql_commands = """
-- Create user_roles table
CREATE TABLE IF NOT EXISTS user_roles (
    id SERIAL PRIMARY KEY,
    role_name VARCHAR(50) UNIQUE NOT NULL,
    role_description TEXT,
    permissions JSONB,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Insert default roles
INSERT INTO user_roles (id, role_name, role_description, permissions) 
VALUES 
    (1, 'admin', 'System Administrator', '["all"]'),
    (2, 'council_user', 'Council Project Manager', '["projects", "milestones", "documents"]'),
    (3, 'supervisor', 'Project Supervisor/Judge', '["validations", "approvals"]'),
    (4, 'auditor', 'System Auditor', '["view_all", "reports"]')
ON CONFLICT (role_name) DO NOTHING;

-- Create councils table with district column
CREATE TABLE IF NOT EXISTS councils (
    id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    location VARCHAR(200),
    district VARCHAR(100),
    created_at TIMESTAMP DEFAULT NOW()
);

-- Add district column if it doesn't exist (for existing tables)
ALTER TABLE councils ADD COLUMN IF NOT EXISTS district VARCHAR(100);

-- Insert default councils with both name and district
INSERT INTO councils (id, name, location, district) 
VALUES 
    (1, 'Freetown City Council', 'Freetown', 'Western Area Urban'),
    (2, 'Bo City Council', 'Bo', 'Bo District'),
    (3, 'Kenema City Council', 'Kenema', 'Kenema District'),
    (4, 'Makeni City Council', 'Makeni', 'Bombali District')
ON CONFLICT (id) DO UPDATE SET 
    location = EXCLUDED.location,
    district = EXCLUDED.district;

-- Create system_users table
CREATE TABLE IF NOT EXISTS system_users (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    email VARCHAR(255) UNIQUE NOT NULL,
    full_name VARCHAR(200) NOT NULL,
    role_id INTEGER REFERENCES user_roles(id),
    council_id INTEGER REFERENCES councils(id),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW(),
    last_login TIMESTAMP
);

-- Insert the missing user record (adjust the UUID and details as needed)
INSERT INTO system_users (id, email, full_name, role_id, council_id, is_active)
VALUES (
    '30efe7a6-4cef-4be4-8ffb-2ffe8a71c5cc'::uuid,
    'gerald@kns.sl',
    'Gerald Thomas',
    1, -- admin role
    NULL, -- no specific council for admin
    TRUE
) ON CONFLICT (id) DO NOTHING;

-- Enable Row Level Security
ALTER TABLE system_users ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_roles ENABLE ROW LEVEL SECURITY;
ALTER TABLE councils ENABLE ROW LEVEL SECURITY;

-- Create policies to allow authenticated users to read/write
CREATE POLICY "Allow authenticated read access" ON system_users
    FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Allow authenticated insert access" ON system_users
    FOR INSERT WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "Allow authenticated update access" ON system_users
    FOR UPDATE USING (auth.role() = 'authenticated');

CREATE POLICY "Allow authenticated read access" ON user_roles
    FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Allow authenticated read access" ON councils
    FOR SELECT USING (auth.role() = 'authenticated');
"""
    
    print("   Copy and paste this SQL into the Supabase SQL Editor:")
    print("   " + "─" * 60)
    print()
    for line in sql_commands.strip().split('\n'):
        print(f"   {line}")
    print()
    print("   " + "─" * 60)
    print()
    
    print("3. 🧪 AFTER MAKING CHANGES:")
    print("   → Go back to: https://council-system-deploy.onrender.com/admin-users.html")
    print("   → Refresh the page")
    print("   → You should now see 'Gerald Thomas' in the user list")
    print("   → Try creating a new user - email confirmation should work correctly")
    print()
    
    print("4. 🔄 If you need to check user creation:")
    print("   → User ID from your token: 30efe7a6-4cef-4be4-8ffb-2ffe8a71c5cc")
    print("   → Email: gerald@kns.sl")
    print("   → This user should now appear in the admin panel")
    print()
    
    print("✅ After completing these steps, both issues should be resolved!")

if __name__ == "__main__":
    main()
