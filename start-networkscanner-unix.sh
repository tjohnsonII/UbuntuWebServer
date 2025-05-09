#!/bin/bash

# ---------------------------------------------------------------------
# Script: start-networkscanner-unix.sh
# Purpose: Robust Flask launcher for Linux/macOS
# Location: /home/<user>/UbuntuWebServer or /Users/<user>/UbuntuWebServer
# ---------------------------------------------------------------------

echo "[INFO] 🚀 Starting Unix Flask Launcher..."

# Detect platform and username
PLATFORM="$(uname -s)"
USERNAME="$(whoami)"

# Define base project directory
if [[ "$PLATFORM" == "Darwin" ]]; then
    BASE_DIR="/Users/$USERNAME/UbuntuWebServer"
    PACKAGE_MANAGER="brew"
elif [[ "$PLATFORM" == "Linux" ]]; then
    BASE_DIR="/home/$USERNAME/UbuntuWebServer"
    PACKAGE_MANAGER="apt-get"
else
    echo "[ERROR] Unsupported OS: $PLATFORM"
    exit 1
fi

# Define paths
PROJECT_DIR="$BASE_DIR"
VENV_DIR="$PROJECT_DIR/venv"
REQUIREMENTS_FILE="$PROJECT_DIR/requirements.txt"

# Change to project directory
echo "[INFO] 📁 Project directory: $PROJECT_DIR"
cd "$PROJECT_DIR" || { echo "[ERROR] Could not access $PROJECT_DIR"; exit 1; }

# ----------------------------
# Check Python 3 availability
# ----------------------------
PYTHON_CMD=$(command -v python3 || command -v python)
if [ -z "$PYTHON_CMD" ]; then
    echo "[ERROR] Python 3.10+ is required but not found."
    exit 1
fi

# ----------------------------
# Check pip availability
# ----------------------------
PIP_CMD=$(command -v pip3 || command -v pip)
if [ -z "$PIP_CMD" ]; then
    echo "[ERROR] pip not found. Please install pip for Python 3."
    exit 1
fi

# ----------------------------
# Create virtual environment if needed
# ----------------------------
if [ ! -d "$VENV_DIR" ]; then
    echo "[*] Creating virtual environment at $VENV_DIR"
    $PYTHON_CMD -m venv "$VENV_DIR"
    if [ $? -ne 0 ]; then
        echo "[ERROR] Failed to create virtual environment."
        exit 1
    fi
fi

# ----------------------------
# Activate virtual environment
# ----------------------------
source "$VENV_DIR/bin/activate"
if [ -z "$VIRTUAL_ENV" ]; then
    echo "[ERROR] Failed to activate virtual environment."
    exit 1
fi

# ----------------------------
# Install Python dependencies
# ----------------------------
if [ -f "$REQUIREMENTS_FILE" ]; then
    echo "[*] Installing dependencies from requirements.txt"
    pip install --upgrade pip
    pip install -r "$REQUIREMENTS_FILE"
else
    echo "[WARN] requirements.txt not found, skipping dependency install."
fi

# ----------------------------
# Ensure sqlite3 is available
# ----------------------------
if ! command -v sqlite3 &>/dev/null; then
    echo "[WARN] sqlite3 not found. Attempting install..."
    if [ "$PACKAGE_MANAGER" == "apt-get" ]; then
        sudo apt-get update && sudo apt-get install -y sqlite3
    elif [ "$PACKAGE_MANAGER" == "brew" ]; then
        brew install sqlite3
    fi
fi

# ----------------------------
# Ensure nmap is available
# ----------------------------
if ! command -v nmap &>/dev/null; then
    echo "[WARN] nmap not found. Attempting install..."
    if [ "$PACKAGE_MANAGER" == "apt-get" ]; then
        sudo apt-get install -y nmap
    elif [ "$PACKAGE_MANAGER" == "brew" ]; then
        brew install nmap
    fi
fi

# ----------------------------
# Start the Flask app
# ----------------------------
echo "[INFO] 🌐 Starting Flask app..."
$PYTHON_CMD -m ubuntuwebserver.app

if [ $? -eq 0 ]; then
    echo "[✓] Flask app started successfully."
else
    echo "[ERROR] Failed to start the Flask app."
    exit 1
fi

# ----------------------------
# Completion
# ----------------------------
echo "[INFO] Script finished on $PLATFORM"
