# PowerShell: start-networkscanner.ps1
# Flask Network Scanner Launcher (for Windows PowerShell)

Write-Host "[INFO] PowerShell Flask launcher started..."

# ------------------------------
# Set project path
# ------------------------------
$projectDir = "$HOME\Documents\UbuntuWebServer"
$venvPath = "$projectDir\venv\Scripts\Activate.ps1"

# ------------------------------
# Check for Python
# ------------------------------
if (-not (Get-Command python -ErrorAction SilentlyContinue)) {
    Write-Error "Python is not installed. Please install Python 3.10+."
    exit 1
}

# ------------------------------
# Create virtual environment
# ------------------------------
if (-not (Test-Path "$projectDir\venv")) {
    Write-Host "[*] Creating virtual environment..."
    python -m venv "$projectDir\venv"
}

# ------------------------------
# Activate virtual environment
# ------------------------------
Write-Host "[*] Activating virtual environment..."
& "$venvPath"

# ------------------------------
# Install Python dependencies
# ------------------------------
if (Test-Path "$projectDir\requirements.txt") {
    Write-Host "[*] Installing Python dependencies..."
    pip install --upgrade pip
    pip install -r "$projectDir\requirements.txt"
} else {
    Write-Warning "requirements.txt not found. Skipping dependency installation."
}

# ------------------------------
# Check for required tools
# ------------------------------
if (-not (Get-Command sqlite3 -ErrorAction SilentlyContinue)) {
    Write-Warning "sqlite3 not found. Install manually: https://sqlite.org/download.html"
}
if (-not (Get-Command nmap -ErrorAction SilentlyContinue)) {
    Write-Warning "nmap not found. Install manually: https://nmap.org/download.html"
}

# ------------------------------
# Run the Flask app
# ------------------------------
Write-Host "[*] Launching Flask app..."
python -m ubuntuwebserver.app

# ------------------------------
# Exit handling
# ------------------------------
if ($LASTEXITCODE -eq 0) {
    Write-Host "[✓] Flask app exited successfully."
} else {
    Write-Host "[ERROR] Flask app exited with error code $LASTEXITCODE"
}

# ------------------------------
# Prompt to close (Windows)
# ------------------------------
Write-Host "[INFO] Press any key to close this window..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
