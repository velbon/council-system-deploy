#!/usr/bin/env python3
"""
PPMS Local Development Server
Simple HTTP server for testing the Public Project Management System
"""

import http.server
import socketserver
import webbrowser
import os
import sys
from pathlib import Path

def main():
    # Configuration
    PORT = 3000  # Changed from 8080 to avoid Jenkins conflict
    DIRECTORY = Path(__file__).parent
    
    # Change to the project directory
    os.chdir(DIRECTORY)
    
    # Create server
    Handler = http.server.SimpleHTTPRequestHandler
    
    try:
        with socketserver.TCPServer(("", PORT), Handler) as httpd:
            print("=" * 60)
            print("🏛️  PPMS Development Server Starting...")
            print("=" * 60)
            print(f"📁 Serving directory: {DIRECTORY}")
            print(f"🌐 Server running at: http://localhost:{PORT}")
            print(f"🔐 Login page: http://localhost:{PORT}/login.html")
            print(f"📊 Main Dashboard: http://localhost:{PORT}/dashboard.html")
            print("=" * 60)
            print("📋 Demo Accounts:")
            print("   Admin:      admin@ppms.sl      / admin123")
            print("   Council:    council@ppms.sl    / council123") 
            print("   Supervisor: supervisor@ppms.sl / super123")
            print("   Auditor:    auditor@ppms.sl    / audit123")
            print("=" * 60)
            print("💡 Press Ctrl+C to stop the server")
            print("=" * 60)
            
            # Open browser automatically
            try:
                webbrowser.open(f'http://localhost:{PORT}/login.html')
                print("🚀 Opening login page in your default browser...")
            except:
                print("⚠️  Could not open browser automatically")
                
            print()
            
            # Start server
            httpd.serve_forever()
            
    except KeyboardInterrupt:
        print("\n")
        print("=" * 60)
        print("🛑 PPMS Server stopped by user")
        print("=" * 60)
        
    except OSError as e:
        if e.errno == 48:  # Address already in use
            print(f"❌ Error: Port {PORT} is already in use")
            print(f"💡 Try using a different port or stop the existing server")
            sys.exit(1)
        else:
            print(f"❌ Error starting server: {e}")
            sys.exit(1)

if __name__ == "__main__":
    main()
