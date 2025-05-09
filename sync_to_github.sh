#!/bin/bash

# ---------------------------------------
# Script: sync_to_github.sh
# Purpose: Sanitize secrets and push to GitHub
# Supports: Linux, macOS, Windows (Git Bash)
# ---------------------------------------

# Detect Windows (Git Bash / MINGW)
IS_WINDOWS=false
case "$(uname -s)" in
    MINGW*|MSYS*|CYGWIN*) IS_WINDOWS=true ;;
esac

# Step 1: Check and scrub .pypirc if it contains a PyPI token
if grep -q "password" .pypirc 2>/dev/null; then
  echo "[!] Detected PyPI token in .pypirc"

  echo "[*] Backing up .pypirc to .pypirc.bak..."
  cp .pypirc .pypirc.bak

  echo "[*] Removing .pypirc from Git tracking..."
  git rm --cached .pypirc

  # Add to .gitignore if not already present
  if ! grep -qxF ".pypirc" .gitignore 2>/dev/null; then
    echo ".pypirc" >> .gitignore
  fi

  echo "[*] Rewinding last commit to scrub token..."
  git reset HEAD~1
fi

# Step 2: Handle .env file (if present)
if [ -f ".env" ]; then
  echo "[!] Found .env file — adding to .gitignore"
  if ! grep -qxF ".env" .gitignore 2>/dev/null; then
    echo ".env" >> .gitignore
  fi
fi

# Step 3: Commit and push changes
echo "[*] Adding changes..."
git add .

echo "[*] Committing..."
git commit -m "Clean sync without secrets"

echo "[*] Pushing to GitHub..."
git push origin main

echo "[✓] Sync complete."

# Step 4: Wait for user confirmation (Windows only)
if [ "$IS_WINDOWS" = true ]; then
  read -n 1 -s -r -p "Press any key to continue . . ."
fi
