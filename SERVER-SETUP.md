# PPMS Server Setup Guide

## 🚀 Quick Start

### Method 1: Using the Custom Server Script (Recommended)
```bash
python3 start-server.py
```
This will:
- Start the server on http://localhost:8080
- Automatically open your browser
- Display demo account credentials
- Show helpful server information

### Method 2: Using Python's Built-in Server
```bash
python3 -m http.server 8080
```
Then open: http://localhost:8080/login.html

### Method 3: Using Node.js (if installed)
```bash
npx http-server -p 8080
```

## 🔧 Troubleshooting

### "NetworkError when attempting to fetch resource"
This error occurs when opening HTML files directly (file:// protocol). You MUST use a web server.

**Solution**: Use any of the server methods above.

### "Port 8080 already in use"
Another application is using port 8080.

**Solutions**:
- Kill the existing process: `lsof -ti:8080 | xargs kill`
- Use a different port: `python3 -m http.server 8081`

### CDN Resources Not Loading
If you see missing styles or JavaScript errors:
- Ensure you have internet connection
- Check browser console for specific errors
- Try refreshing the page

## 🎯 Testing the System

### 1. Start Server
```bash
python3 start-server.py
```

### 2. Access Login Page
Open: http://localhost:8080/login.html

### 3. Demo Accounts
| Role | Email | Password |
|------|-------|----------|
| Admin | admin@ppms.sl | admin123 |
| Council User | council@ppms.sl | council123 |
| Supervisor | supervisor@ppms.sl | super123 |
| Auditor | auditor@ppms.sl | audit123 |

### 4. Test Features
- Login with different roles
- Admin: Create new users
- Council User: Project management
- Supervisor: Validation workflows
- Auditor: Read-only access

## 🌐 Production Deployment

For production deployment:

### Apache/Nginx
Upload all HTML files to your web server document root.

### Netlify/Vercel
1. Create a new site
2. Upload the entire folder
3. Set `login.html` as the entry point

### GitHub Pages
1. Push to a GitHub repository
2. Enable GitHub Pages
3. Set custom domain if needed

## 🔒 Security Notes

- Demo accounts are for testing only
- Configure real Supabase credentials for production
- Use HTTPS in production
- Set up proper authentication tokens
- Configure CORS settings appropriately

## 📞 Support

If you encounter issues:
1. Check browser console for errors
2. Ensure server is running properly
3. Verify network connectivity
4. Check Supabase configuration

---
*PPMS - Public Project Management System for Sierra Leone*
