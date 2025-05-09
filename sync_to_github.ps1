# --------------------------------------------
# Script: sync_to_github.ps1
# Purpose: Sanitize secrets and push to GitHub (PowerShell version)
# Supports: Windows PowerShell and CMD
# --------------------------------------------

Write-Host "[*] Starting GitHub sync script (PowerShell)..."

# Step 1: Handle .pypirc
if (Test-Path ".pypirc" -PathType Leaf) {
    $pypircContent = Get-Content ".pypirc" -Raw
    if ($pypircContent -match "password") {
        Write-Host "[!] Detected PyPI token in .pypirc"

        Write-Host "[*] Backing up .pypirc to .pypirc.bak..."
        Copy-Item ".pypirc" ".pypirc.bak" -Force

        Write-Host "[*] Removing .pypirc from Git tracking..."
        git rm --cached .pypirc

        if (-not (Select-String -Path ".gitignore" -Pattern "\.pypirc" -Quiet)) {
            Add-Content ".gitignore" ".pypirc"
        }

        Write-Host "[*] Rewinding last commit to scrub token..."
        git reset HEAD~1
    }
}

# Step 2: Handle .env
if (Test-Path ".env" -PathType Leaf) {
    Write-Host "[!] Found .env file — adding to .gitignore"
    if (-not (Select-String -Path ".gitignore" -Pattern "\.env" -Quiet)) {
        Add-Content ".gitignore" ".env"
    }
}

# Step 3: Commit and push
Write-Host "[*] Adding changes..."
git add .

Write-Host "[*] Committing..."
git commit -m "Clean sync without secrets"

Write-Host "[*] Pushing to GitHub..."
git push origin main

Write-Host "[✓] Sync complete."
Pause
