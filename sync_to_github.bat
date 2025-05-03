@echo off
cd /d "%USERPROFILE%\Documents\VSCodeProjects\UbuntuWebServer"

echo [*] Adding changes...
git add .

echo [*] Committing...
git commit -m "Auto sync update"

echo [*] Pushing to GitHub...
git push origin main

echo [✓] Sync complete.
pause
