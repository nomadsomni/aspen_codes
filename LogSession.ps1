# ================================
# PowerShell Startup Logging Script with Compression
# Author: Nomad
# ================================

# === CONFIGURATION ===
# Set your preferred log folder path here:
$LogFolder = "C:\Users\Surface\OneDrive\SIRENSSD\Research Lab\Records and logging"

# Create folder if it doesn't exist
if (-not (Test-Path -Path $LogFolder)) {
    New-Item -ItemType Directory -Path $LogFolder -Force
}

# === Generate Date-Time based filename ===
$DateTime = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$LogFile = "$LogFolder\aspen_codes:session_$DateTime.txt"

# === Start Transcript ===
Start-Transcript -Path $LogFile *>$null

Write-Host "aspen_codes:: session launched."

# === Your startup commands below ===
Set-Location "C:\Users\Surface\OneDrive\SIRENSSD\"

# === Function to Stop Transcript and Compress ===
function Stop-LoggingSession {
    # Stop transcript
    Stop-Transcript

    # Compress the log file
    $ZipFile = "$LogFile.zip"
    Compress-Archive -Path $LogFile -DestinationPath $ZipFile

    # Remove the original uncompressed log file
    Remove-Item -Path $LogFile -Force

    Write-Host "aspen_codes:: session ended. Log file compressed to: $ZipFile"
}

# === Register function to run at session end ===
# Ensures compression happens when PowerShell exits
Register-EngineEvent PowerShell.Exiting -Action { Stop-LoggingSession } | Out-Null

# ================================
# Notes:
# - This uses PowerShell's built-in Compress-Archive cmdlet.
# - On exit, transcript stops and compresses automatically.
# ================================
