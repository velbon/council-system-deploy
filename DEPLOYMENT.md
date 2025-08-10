# Sierra Leone Council Dashboard - Production Deployment Guide

## 🚀 Quick Deploy Options

### 1. Heroku (Recommended for beginners)
```bash
# Install Heroku CLI
brew install heroku/brew/heroku

# Login to Heroku
heroku login

# Create app
heroku create council-system-sl

# Deploy
git push heroku master

# Open app
heroku open
```

### 2. Railway
- Go to [railway.app](https://railway.app)
- Connect your GitHub repository
- Deploy automatically

### 3. Render
- Go to [render.com](https://render.com)
- Connect your GitHub repository
- Use these settings:
  - Build Command: `pip install -r requirements.txt`
  - Start Command: `gunicorn app:app`

### 4. DigitalOcean App Platform
- Go to DigitalOcean → Apps
- Create new app from GitHub
- Select this repository

## 🐳 Docker Deployment

### Local Testing
```bash
# Build and run
docker-compose up --build

# Access at http://localhost:8000
```

### Production Server
```bash
# Build image
docker build -t council-dashboard .

# Run container
docker run -d -p 80:8000 --name council-app council-dashboard

# Check health
curl http://your-server/health
```

## 🔧 Environment Variables

Set these in your hosting platform:
- `PORT`: Server port (default: 8000)
- `FLASK_ENV`: Set to "production"

## 🔍 Monitoring

- Health check endpoint: `/health`
- Returns: `{"status": "healthy", "service": "council-dashboard"}`

## 📱 Access URLs

Once deployed, your application will be available at:
- **Login**: `https://your-app.herokuapp.com/login.html`
- **Dashboard**: `https://your-app.herokuapp.com/dashboard.html`
- **Admin**: `https://your-app.herokuapp.com/admin.html`

## 🔐 Demo Accounts

- Admin: `admin@ppms.sl` / `admin123`
- Council: `council@ppms.sl` / `council123`
- Supervisor: `supervisor@ppms.sl` / `super123`
- Auditor: `auditor@ppms.sl` / `audit123`
