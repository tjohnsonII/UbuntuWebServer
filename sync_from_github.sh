#!/bin/bash

#update UbuntuWebServer

cd ~/UbuntuWebServer || exit 1

echo "[*] Pulling latest changes from GitHub..."
git stash --include-untracked
git pull origin main
git stash pop

echo "[*] Ensuring sqlite3 is installed..."
sudo apt-get update -y
sudo apt-get install -y sqlite3

echo "[*] Running DB initialization..."
source venv/bin/activate
python init_db.py

echo "[*] Restarting Flask app..."
pkill -f "python app.py"
nohup python app.py > flask.log 2>&1 &

echo "[✓] Sync, DB check, and restart complete."
