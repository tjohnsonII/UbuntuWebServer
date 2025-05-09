@echo off
:: ------------------------------------------------------
:: Windows CMD Launcher - start-networkscanner.bat
:: Purpose: Dispatch to PowerShell to launch Flask scanner
:: ------------------------------------------------------

set SCRIPT=start-networkscanner.ps1

echo [INFO] CMD launcher started...
echo [INFO] Looking for PowerShell executable...

:: Check if PowerShell is available
where powershell.exe >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] PowerShell is not installed or not found in PATH.
    echo [HINT] This script requires PowerShell to run. Install it from:
    echo        https://github.com/PowerShell/PowerShell
    pause
    exit /b 1
)

:: Check if script exists
if not exist "%SCRIPT%" (
    echo [ERROR] Could not find %SCRIPT% in the current directory.
    echo [INFO] Current directory: %CD%
    pause
    exit /b 1
)

:: Run PowerShell with elevated ExecutionPolicy
echo [INFO] Executing: PowerShell -File %SCRIPT%
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT%"

:: Capture exit status
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] PowerShell script failed with exit code %ERRORLEVEL%.
    pause
    exit /b %ERRORLEVEL%
)

echo [✓] Flask app executed successfully.
pause
exit /b 0
