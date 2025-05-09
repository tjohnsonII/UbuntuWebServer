#!/bin/bash

# ============================================================================
# Script: start-networkscanner.sh
# Purpose: Cross-platform launcher for the UbuntuWebServer Flask scanner app.
#          This script detects the current operating system and delegates
#          execution to the appropriate platform-specific launcher:
#              - start-networkscanner-unix.sh   → Linux/macOS
#              - start-networkscanner.ps1       → Windows PowerShell
# ============================================================================
# Usage:
#   ./start-networkscanner.sh
# ============================================================================

# Detect the current OS using uname
OS="$(uname -s)"

# Branch logic based on OS type
case "$OS" in
    # ----------------------------
    # Windows systems using Git Bash / MSYS2 / Cygwin
    # ----------------------------
    MINGW*|MSYS*|CYGWIN*)
        echo "[INFO] Detected Windows environment (Git Bash or similar)"
        echo "[INFO] Handing off to PowerShell script: start-networkscanner.ps1"

        # Call PowerShell script with execution policy bypassed for flexibility
        powershell.exe -ExecutionPolicy Bypass -File "./start-networkscanner.ps1"
        ;;

    # ----------------------------
    # macOS or Linux (Unix-like)
    # ----------------------------
    Darwin*|Linux)
        echo "[INFO] Detected Unix-based system (Linux or macOS)"
        echo "[INFO] Executing: start-networkscanner-unix.sh"

        # Run the corresponding bash script
        bash ./start-networkscanner-unix.sh
        ;;

    # ----------------------------
    # Unknown or unsupported OS
    # ----------------------------
    *)
        echo "[ERROR] Unsupported or unknown OS: $OS"
        echo "[HINT] You may need to manually run the appropriate startup script."
        exit 1
        ;;
esac
