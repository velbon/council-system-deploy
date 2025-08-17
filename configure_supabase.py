#!/usr/bin/env python3
"""
Supabase Configuration Script for PPMS
Automatically updates all HTML files with your real Supabase credentials
"""

import os
import re
import glob
from typing import List, Tuple

class SupabaseConfigurator:
    def __init__(self, project_dir: str = "."):
        self.project_dir = project_dir
        self.backup_suffix = ".backup"
        
        # Files that contain Supabase configuration
        self.html_files = [
            "admin-users.html",
            "admin-enhanced.html",
            "council-user.html", 
            "supervisor.html",
            "auditor.html",
            "login.html",
            "admin.html",
            "notifications.html",
            "reports.html"
        ]
        
        # Patterns to find and replace
        self.url_pattern = r"const SUPABASE_URL = ['\"]https://your-project\.supabase\.co['\"];"
        self.key_pattern = r"const SUPABASE_ANON_KEY = ['\"]your-anon-key['\"];"
        
    def get_credentials(self) -> Tuple[str, str]:
        """Get Supabase credentials from user input"""
        print("🔑 Supabase Configuration Setup")
        print("=" * 50)
        print()
        print("Please provide your Supabase credentials from your project dashboard.")
        print("Go to: Settings → API → Project URL and API Key (anon public)")
        print()
        
        # Get Project URL
        while True:
            url = input("📍 Enter your Supabase Project URL: ").strip()
            if url.startswith("https://") and ".supabase.co" in url:
                break
            print("❌ Invalid URL format. Should be: https://[your-project].supabase.co")
        
        # Get API Key
        while True:
            key = input("🔐 Enter your Supabase API Key (anon public): ").strip()
            if key.startswith("eyJ") and len(key) > 100:
                break
            print("❌ Invalid API key format. Should start with 'eyJ' and be quite long")
        
        return url, key
    
    def backup_file(self, file_path: str) -> str:
        """Create a backup of the original file"""
        backup_path = file_path + self.backup_suffix
        with open(file_path, 'r', encoding='utf-8') as original:
            with open(backup_path, 'w', encoding='utf-8') as backup:
                backup.write(original.read())
        return backup_path
    
    def update_file(self, file_path: str, supabase_url: str, supabase_key: str) -> bool:
        """Update a single file with Supabase credentials"""
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()
            
            # Check if file contains Supabase configuration
            if "SUPABASE_URL" not in content and "SUPABASE_ANON_KEY" not in content:
                return False
            
            # Create backup
            backup_path = self.backup_file(file_path)
            print(f"  📁 Backup created: {backup_path}")
            
            # Replace URL
            new_url_line = f"const SUPABASE_URL = '{supabase_url}';"
            content = re.sub(self.url_pattern, new_url_line, content)
            
            # Replace API Key
            new_key_line = f"const SUPABASE_ANON_KEY = '{supabase_key}';"
            content = re.sub(self.key_pattern, new_key_line, content)
            
            # Write updated content
            with open(file_path, 'w', encoding='utf-8') as f:
                f.write(content)
            
            return True
            
        except Exception as e:
            print(f"  ❌ Error updating {file_path}: {str(e)}")
            return False
    
    def find_html_files(self) -> List[str]:
        """Find all HTML files that need updating"""
        found_files = []
        
        # Check specific files
        for filename in self.html_files:
            file_path = os.path.join(self.project_dir, filename)
            if os.path.exists(file_path):
                found_files.append(file_path)
        
        # Also search for any other HTML files with Supabase config
        all_html = glob.glob(os.path.join(self.project_dir, "*.html"))
        for html_file in all_html:
            if html_file not in found_files:
                try:
                    with open(html_file, 'r', encoding='utf-8') as f:
                        content = f.read()
                        if "SUPABASE_URL" in content or "SUPABASE_ANON_KEY" in content:
                            found_files.append(html_file)
                except:
                    pass
        
        return found_files
    
    def configure(self):
        """Main configuration process"""
        print()
        print("🚀 PPMS Supabase Configuration Tool")
        print("=" * 50)
        print()
        
        # Find HTML files
        html_files = self.find_html_files()
        if not html_files:
            print("❌ No HTML files with Supabase configuration found!")
            return
        
        print(f"📄 Found {len(html_files)} files to update:")
        for f in html_files:
            print(f"   • {os.path.basename(f)}")
        print()
        
        # Get credentials
        supabase_url, supabase_key = self.get_credentials()
        print()
        
        # Confirm before proceeding
        confirm = input("🤔 Ready to update files? (y/N): ").strip().lower()
        if confirm not in ['y', 'yes']:
            print("❌ Configuration cancelled.")
            return
        
        print()
        print("⚙️  Updating files...")
        print()
        
        # Update each file
        updated_count = 0
        for file_path in html_files:
            filename = os.path.basename(file_path)
            print(f"🔄 Updating {filename}...")
            
            if self.update_file(file_path, supabase_url, supabase_key):
                print(f"  ✅ Successfully updated!")
                updated_count += 1
            else:
                print(f"  ⚠️  No Supabase config found or error occurred")
        
        print()
        print("=" * 50)
        print(f"🎉 Configuration Complete!")
        print(f"   Updated: {updated_count} files")
        print(f"   Backups created with '.backup' extension")
        print()
        print("📋 Next Steps:")
        print("1. Test your setup by opening login.html in a browser")
        print("2. Check browser console - should not see 'demo mode' message")
        print("3. Try creating a user in admin panel")
        print("4. If issues occur, restore from .backup files")
        print()
    
    def restore_backups(self):
        """Restore all files from backups"""
        backup_files = glob.glob(os.path.join(self.project_dir, "*.backup"))
        if not backup_files:
            print("❌ No backup files found!")
            return
        
        print(f"🔄 Found {len(backup_files)} backup files")
        confirm = input("🤔 Restore all files from backups? (y/N): ").strip().lower()
        if confirm not in ['y', 'yes']:
            print("❌ Restore cancelled.")
            return
        
        restored = 0
        for backup_file in backup_files:
            original_file = backup_file.replace(self.backup_suffix, "")
            try:
                with open(backup_file, 'r', encoding='utf-8') as backup:
                    with open(original_file, 'w', encoding='utf-8') as original:
                        original.write(backup.read())
                print(f"✅ Restored: {os.path.basename(original_file)}")
                restored += 1
            except Exception as e:
                print(f"❌ Error restoring {original_file}: {str(e)}")
        
        print(f"\n🎉 Restored {restored} files from backups!")

def main():
    """Main entry point"""
    configurator = SupabaseConfigurator()
    
    if len(os.sys.argv) > 1 and os.sys.argv[1] == "--restore":
        configurator.restore_backups()
    else:
        configurator.configure()

if __name__ == "__main__":
    main()
