# 🚀 Supabase Setup Guide for PPMS
*Complete guide to set up real database for the Public Project Management System*

## 📋 Prerequisites
- A modern web browser
- Access to [supabase.com](https://supabase.com)
- Your existing PPMS project files

## 🎯 Step-by-Step Setup

### Step 1: Create Supabase Account & Project

1. **Visit Supabase**: Go to [supabase.com](https://supabase.com)
2. **Sign Up/Login**: Create account or login with GitHub/Google
3. **Create New Project**:
   - Click "New Project"
   - Choose your organization (or create one)
   - **Project Name**: `ppms-sierra-leone` (or your preferred name)
   - **Database Password**: Generate a strong password (save this!)
   - **Region**: Choose closest to Sierra Leone (e.g., "Frankfurt" or "London")
   - **Pricing Plan**: Start with "Free" plan
4. **Wait for Setup**: Project creation takes 2-3 minutes

### Step 2: Get Your Credentials

Once your project is ready:

1. **Go to Settings**: Click "Settings" in left sidebar
2. **API Section**: Click "API" tab
3. **Copy These Values** (save them securely):
   ```
   Project URL: https://[your-project-ref].supabase.co
   API Key (anon public): eyJ... (long string starting with eyJ)
   ```

### Step 3: Set Up Database Schema

1. **Open SQL Editor**: Go to "SQL Editor" in left sidebar
2. **Create New Query**: Click "New Query"
3. **Copy Schema**: Copy the entire contents of `user-management-schema.sql`
4. **Paste & Execute**: Paste the SQL and click "Run"
5. **Verify Tables**: Go to "Table Editor" to see created tables

### Step 4: Enable Authentication

1. **Go to Authentication**: Click "Authentication" in sidebar
2. **Settings Tab**: Click "Settings" tab
3. **Configure Email**:
   - Enable "Enable email confirmations" (optional)
   - Set "Site URL" to your domain or `http://localhost:8000`
4. **Enable Providers**:
   - Email is enabled by default
   - Optionally enable Google/GitHub for social login

### Step 5: Configure Storage (for document uploads)

1. **Go to Storage**: Click "Storage" in sidebar
2. **Create Bucket**: Click "Create bucket"
   - **Name**: `project-documents`
   - **Public**: No (keep private)
   - **File size limit**: 50MB
3. **Set Policies** (for later): We'll configure access policies

### Step 6: Update Your PPMS Configuration

Use the configuration script I'll create, or manually update these files:

**Files to Update:**
- `admin-users.html`
- `admin-enhanced.html` 
- `council-user.html`
- `supervisor.html`
- `auditor.html`
- `login.html`

**Replace these lines:**
```javascript
const SUPABASE_URL = 'https://your-project.supabase.co';
const SUPABASE_ANON_KEY = 'your-anon-key';
```

**With your actual values:**
```javascript
const SUPABASE_URL = 'https://[your-project-ref].supabase.co';
const SUPABASE_ANON_KEY = 'eyJ[your-actual-anon-key]';
```

## 🔧 Configuration Details

### Required Tables
Your schema creates these essential tables:
- ✅ `user_roles` - System roles (admin, council_user, supervisor, auditor)
- ✅ `system_users` - User management with role assignments
- ✅ `project_validations` - Workflow validation system
- ✅ `project_milestones` - Project milestone tracking
- ✅ `project_documents` - File management
- ✅ `audit_logs` - Complete activity tracking

### Default Roles Created
- **admin**: Full system access
- **council_user**: Council-specific project management
- **supervisor**: Validation and approval workflows  
- **auditor**: Read-only system access

## 🛡️ Security Considerations

### Row Level Security (RLS)
Currently disabled for easier setup. To enable:
```sql
ALTER TABLE system_users ENABLE ROW LEVEL SECURITY;
-- Add policies for each table
```

### Environment Variables
Create a `.env` file to store credentials securely:
```bash
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key
```

## 🧪 Testing Your Setup

### Test Database Connection
1. Open any PPMS page (e.g., `login.html`)
2. Open browser Developer Tools (F12)
3. Check Console for errors
4. Should see successful Supabase connection (no demo mode message)

### Test User Creation
1. Login as admin (admin@ppms.sl / admin123)
2. Go to User Management
3. Try creating a new user
4. Check if user appears in Supabase dashboard

### Test Authentication
1. Go to `login.html`
2. Try logging in with demo credentials
3. Should redirect to appropriate dashboard

## 🚨 Troubleshooting

### Common Issues

**"Using demo mode" message:**
- Check SUPABASE_URL and SUPABASE_ANON_KEY are correct
- Verify no extra spaces or quotes in values

**"Invalid API key" error:**
- Ensure you copied the "anon public" key, not service key
- Check key hasn't been regenerated in Supabase

**"Table doesn't exist" error:**
- Verify `user-management-schema.sql` ran successfully
- Check Table Editor in Supabase dashboard

**CORS errors:**
- Add your domain to "Site URL" in Supabase Auth settings
- For local development, use `http://localhost:8000`

### Getting Help
- Check Supabase logs in dashboard
- Review browser console for detailed errors
- Verify all tables exist in Table Editor

## 📊 Next Steps

Once setup is complete:

1. **Create Admin User**: First user should be created via Supabase Auth
2. **Import Council Data**: Add your Sierra Leone councils
3. **Configure Projects**: Set up project templates and KPIs
4. **Enable RLS**: For production security
5. **Set up Email**: Configure SMTP for notifications

## 🎉 Success Indicators

You'll know setup is successful when:
- ✅ No "demo mode" messages in browser console
- ✅ Users can be created and appear in Supabase dashboard
- ✅ Login authentication works properly
- ✅ Role-based access control functions
- ✅ Data persists between browser sessions

---

**Need Help?** Check the troubleshooting section above or review the browser console for specific error messages.
