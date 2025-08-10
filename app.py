#!/usr/bin/env python3
"""
Sierra Leone Council Dashboard - Production Flask App
Serves the static HTML files with proper routing for production deployment
"""

from flask import Flask, send_from_directory, redirect
import os
from pathlib import Path

app = Flask(__name__, static_folder='.', static_url_path='')

@app.route('/')
def index():
    """Redirect root to login page"""
    return redirect('/login.html')

@app.route('/<path:filename>')
def serve_static(filename):
    """Serve static files"""
    return send_from_directory('.', filename)

@app.route('/health')
def health_check():
    """Health check endpoint for production monitoring"""
    return {'status': 'healthy', 'service': 'council-dashboard'}, 200

if __name__ == '__main__':
    # For development and production
    port = int(os.environ.get('PORT', 3000))
    app.run(host='0.0.0.0', port=port, debug=False)
