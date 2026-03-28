# ================================
# PowerShell Startup Logging Script
# Author: Nomad
# Purpose: Start transcript with date-time based filename
# ================================

# === CONFIGURATION ===
# Set your preferred log folder path here:
$LogFolder = "C:\Users\Surface\OneDrive\SIRENSSD\Research Lab\Records and logging"

# Create the folder if it doesn't exist
if (-not (Test-Path -Path $LogFolder)) {
    New-Item -ItemType Directory -Path $LogFolder -Force
}

# === Generate Date-Time based filename ===
$DateTime = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$LogFile = "$LogFolder\Session_$DateTime.txt"

# === Start Transcript ===
Start-Transcript -Path $LogFile

# === Optional: Print location for your awareness ===
Write-Host "Session logging started. Log file: $LogFile"

# === Your startup commands below ===
# For example, navigate to your default directory
Set-Location "C:\Users\Surface\OneDrive\SIRENSSD\"

# ================================
# Note: Remember to run Stop-Transcript at end of session or script
# ================================
