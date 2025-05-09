#!/bin/bash

# ---------------------------------------
# Script: sync_from_github.sh
# Purpose: Sync latest code from GitHub, initialize DB, restart Flask app
# Supports: Linux, Windows (MINGW / Git Bash)
# ---------------------------------------

# Detect OS
IS_WINDOWS=false
case "$(uname -s)" in
    MINGW*|MSYS*|CYGWIN*) IS_WINDOWS=true ;;
esac

# Move to script's directory (works cross-platform)
cd "$(dirname "$0")" || exit 1

# Step 1: Pull latest changes from GitHub
echo "[*] Pulling latest changes from GitHub..."
git stash --include-untracked
git pull origin main
git stash pop

# Step 2: Ensure sqlite3 is installed (Linux only)
if [ "$IS_WINDOWS" = false ]; then
    echo "[*] Ensuring sqlite3 is installed..."
    sudo apt-get update -y
    sudo apt-get install -y sqlite3
else
    echo "[*] Skipping apt-get install on Windows."
fi

# Step 3: Activate virtualenv and initialize DB
echo "[*] Running DB initialization..."
if [ "$IS_WINDOWS" = true ]; then
    source venv/Scripts/activate
else
    source venv/bin/activate
fi

python init_db.py

# Step 4: Restart Flask App
echo "[*] Restarting Flask app..."
if [ "$IS_WINDOWS" = true ]; then
    # Windows: kill by task name
    taskkill //F //IM python.exe 2> /dev/null
    nohup python app.py > flask.log 2>&1 &
else
    # Linux: kill by process match
    pkill -f "python app.py"
    nohup python app.py > flask.log 2>&1 &
fi

# Done
echo "[✓] Sync, DB check, and restart complete."
echo "[✓] Flask app is running. Check flask.log for output."
echo "[✓] All tasks completed successfully."
echo "[✓] Script finished."