#!/usr/bin/env python3
"""
Sierra Leone Council Dashboard - Production Flask App
Serves the static HTML files with proper routing for production deployment
"""

from flask import Flask, send_from_directory, redirect, jsonify, request
import os
from pathlib import Path

app = Flask(__name__, static_folder='.', static_url_path='')

# Add CORS headers to allow external resources
@app.after_request
def after_request(response):
    response.headers.add('Access-Control-Allow-Origin', '*')
    response.headers.add('Access-Control-Allow-Headers', 'Content-Type,Authorization')
    response.headers.add('Access-Control-Allow-Methods', 'GET,PUT,POST,DELETE')
    # Add security headers
    response.headers.add('X-Content-Type-Options', 'nosniff')
    response.headers.add('X-Frame-Options', 'DENY')
    return response

@app.route('/')
def index():
    """Redirect root to login page"""
    return redirect('/login.html')

@app.route('/<path:filename>')
def serve_static(filename):
    """Serve static files with proper error handling"""
    try:
        return send_from_directory('.', filename)
    except Exception as e:
        print(f"Error serving {filename}: {e}")
        # Fallback for problematic pages
        if filename in ['reports.html', 'auditor.html', 'dashboard-enhanced.html']:
            fallback = filename.replace('.html', '-simple.html')
            if os.path.exists(fallback):
                return send_from_directory('.', fallback)
        return f"File not found: {filename}", 404

@app.route('/health')
def health_check():
    """Health check endpoint for production monitoring"""
    return {'status': 'healthy', 'service': 'council-dashboard'}, 200

@app.route('/api/test')
def api_test():
    """Test API endpoint"""
    return jsonify({
        'status': 'working',
        'message': 'Flask API is functioning',
        'files_available': [
            f for f in os.listdir('.') 
            if f.endswith('.html')
        ]
    })

if __name__ == '__main__':
    # For development and production
    port = int(os.environ.get('PORT', 3000))
    app.run(host='0.0.0.0', port=port, debug=False)
