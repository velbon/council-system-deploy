# 🚀 Quick Start: Enable Real User Creation in PPMS

Your Public Project Management System is currently running in **demo mode**. Follow this guide to enable real user creation with a live database.

## 📋 What You Need
1. ✅ Your existing PPMS files (you have these)
2. ✅ A free Supabase account
3. ✅ 15 minutes to set up

## 🎯 Step-by-Step Setup

### Step 1: Create Supabase Project (5 minutes)
1. Go to [supabase.com](https://supabase.com)
2. Sign up/login with GitHub or Google
3. Create new project:
   - Name: `ppms-sierra-leone`
   - Choose region closest to Sierra Leone (Frankfurt/London)
   - Generate strong password
   - Select "Free" plan

### Step 2: Set Up Database (3 minutes)
1. In Supabase dashboard, go to **SQL Editor**
2. Click **"New Query"**
3. Copy entire contents of `user-management-schema.sql`
4. Paste and click **"Run"**
5. Verify tables created in **Table Editor**

### Step 3: Get Credentials (1 minute)
1. Go to **Settings → API**
2. Copy these values:
   - **Project URL**: `https://[your-ref].supabase.co`
   - **API Key (anon public)**: `eyJ...` (long string)

### Step 4: Configure Your PPMS (2 minutes)

**Option A: Use the Configuration Script (Recommended)**
```bash
python3 configure_supabase.py
```
- Enter your Supabase URL and API key when prompted
- Script updates all HTML files automatically
- Creates backups of original files

**Option B: Manual Configuration**
Update these files manually:
- `admin-users.html`
- `admin-enhanced.html`
- `council-user.html`
- `supervisor.html`
- `auditor.html`
- `login.html`

Replace:
```javascript
const SUPABASE_URL = 'https://your-project.supabase.co';
const SUPABASE_ANON_KEY = 'your-anon-key';
```

With your actual values:
```javascript
const SUPABASE_URL = 'https://your-actual-project.supabase.co';
const SUPABASE_ANON_KEY = 'your-actual-api-key';
```

### Step 5: Test Everything (2 minutes)
1. Open `test_supabase.html` in browser
2. Should auto-populate with your credentials
3. Click **"Test Connection"**
4. All tests should be ✅ green

### Step 6: Create Storage Bucket (2 minutes)
1. In Supabase, go to **Storage**
2. Click **"Create bucket"**
3. Name: `project-documents`
4. Keep private (not public)
5. File size limit: 50MB

## 🎉 Success! You're Done!

Your PPMS can now:
- ✅ Create real users that persist in database
- ✅ Handle proper authentication 
- ✅ Store data permanently
- ✅ Support file uploads
- ✅ Audit all activities

## 🧪 Test User Creation

1. Open `login.html`
2. Login as admin: `admin@ppms.sl` / `admin123`
3. Go to User Management
4. Click "Create New User"
5. Fill in details and create
6. User should appear in Supabase dashboard!

## 🚨 Troubleshooting

**Still seeing "demo mode"?**
- Check credentials are correct in HTML files
- Verify no typos in URL/API key
- Make sure schema SQL ran successfully

**"Table doesn't exist" errors?**
- Run `user-management-schema.sql` in Supabase SQL Editor
- Check all tables appear in Table Editor

**Need to restore original files?**
```bash
python3 configure_supabase.py --restore
```

## 📁 Files Created

✅ `SUPABASE_SETUP.md` - Detailed setup guide  
✅ `configure_supabase.py` - Automatic configuration script  
✅ `test_supabase.html` - Connection testing tool  
✅ `.env.template` - Environment variables template  
✅ `.gitignore` - Protect credentials from version control  

## 🎯 What Changed?

**Before (Demo Mode):**
- Users stored only in browser memory
- Data lost on page refresh
- "Using demo mode" console message

**After (Real Database):**
- Users stored in PostgreSQL database
- Data persists permanently
- Full authentication system
- Audit trails and security

---

**Questions?** Check `SUPABASE_SETUP.md` for detailed instructions and troubleshooting.
