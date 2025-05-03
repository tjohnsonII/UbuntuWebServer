#!/bin/bash

cd ~/UbuntuWebServer || { echo "❌ Failed to cd into UbuntuWebServer"; exit 1; }

echo "[*] Ensuring sqlite3 is installed..."
if ! command -v sqlite3 &> /dev/null; then
    echo "[*] Installing sqlite3..."
    sudo apt-get update
    sudo apt-get install -y sqlite3
else
    echo "[✓] sqlite3 is already installed."
fi

echo "[*] Pulling latest changes from GitHub..."
git pull origin main

echo "[*] Activating virtual environment..."
source venv/bin/activate

echo "[*] Restarting Flask app..."
pkill -f "python app.py"
nohup python app.py > flask.log 2>&1 &

echo "[✓] Sync and restart complete."
