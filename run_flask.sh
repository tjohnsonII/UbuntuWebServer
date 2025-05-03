#!/bin/bash
echo "[*] Killing old Flask processes..."
sudo fuser -k 5000/tcp > /dev/null 2>&1

echo "[*] Starting Flask..."
source venv/bin/activate
python app.py
