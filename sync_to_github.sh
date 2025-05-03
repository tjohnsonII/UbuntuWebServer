#!/bin/bash
echo "[*] Adding changes..."
git add .
echo "[*] Committing..."
git commit -m "Auto sync update"
echo "[*] Pushing to GitHub..."
git push origin main
echo "[✓] Sync complete."
read -n 1 -s -r -p "Press any key to continue . . ."
