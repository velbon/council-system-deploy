-- Fix RLS recursion issues
-- Run these commands in your Supabase SQL editor

-- 1. Temporarily disable RLS on problematic tables
ALTER TABLE users DISABLE ROW LEVEL SECURITY;
ALTER TABLE councils DISABLE ROW LEVEL SECURITY;
ALTER TABLE projects DISABLE ROW LEVEL SECURITY;
ALTER TABLE updates DISABLE ROW LEVEL SECURITY;
ALTER TABLE documents DISABLE ROW LEVEL SECURITY;

-- 2. Drop all existing policies
DROP POLICY IF EXISTS "Users can view project files" ON documents;
DROP POLICY IF EXISTS "Authenticated users can upload files" ON documents;
DROP POLICY IF EXISTS "Users can delete files" ON documents;

-- 3. Create simple, non-recursive policies for anonymous access
-- Allow anonymous read access to councils
CREATE POLICY "Allow anonymous read councils" ON councils
  FOR SELECT USING (true);

-- Allow anonymous read access to projects
CREATE POLICY "Allow anonymous read projects" ON projects
  FOR SELECT USING (true);

-- Allow anonymous read access to updates
CREATE POLICY "Allow anonymous read updates" ON updates
  FOR SELECT USING (true);

-- Allow anonymous read access to documents
CREATE POLICY "Allow anonymous read documents" ON documents
  FOR SELECT USING (true);

-- Allow anonymous insert to updates (for submitting progress)
CREATE POLICY "Allow anonymous insert updates" ON updates
  FOR INSERT WITH CHECK (true);

-- Allow anonymous insert to documents (for file uploads)
CREATE POLICY "Allow anonymous insert documents" ON documents
  FOR INSERT WITH CHECK (true);

-- 4. Re-enable RLS
ALTER TABLE councils ENABLE ROW LEVEL SECURITY;
ALTER TABLE projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE updates ENABLE ROW LEVEL SECURITY;
ALTER TABLE documents ENABLE ROW LEVEL SECURITY;

-- Note: Keep users table RLS disabled for now to avoid recursion
-- ALTER TABLE users ENABLE ROW LEVEL SECURITY;

-- 5. Storage policies - allow anonymous access
-- Create policy for documents bucket
INSERT INTO storage.buckets (id, name, public) 
VALUES ('documents', 'documents', true) 
ON CONFLICT (id) DO UPDATE SET public = true;

-- Allow anonymous uploads to documents bucket
CREATE POLICY "Allow anonymous upload documents" ON storage.objects
  FOR INSERT WITH CHECK (bucket_id = 'documents');

-- Allow anonymous read from documents bucket  
CREATE POLICY "Allow anonymous read documents storage" ON storage.objects
  FOR SELECT USING (bucket_id = 'documents');

-- Allow anonymous delete from documents bucket (optional)
CREATE POLICY "Allow anonymous delete documents storage" ON storage.objects
  FOR DELETE USING (bucket_id = 'documents');
