param(
    [Parameter(Mandatory)]
    [string]$SourceFile,

    [Parameter(Mandatory)]
    [string]$BackupDir
)

try {
    # Validate source
    if (-not (Test-Path $SourceFile)) {
        throw "Source file does not exist: $SourceFile"
    }

    # Ensure backup directory exists
    if (-not (Test-Path $BackupDir)) {
        New-Item -ItemType Directory -Path $BackupDir -Force | Out-Null
    }

    # Build backup name with timestamp
    $timestamp = (Get-Date).ToString("yyyy-MM-dd_HH-mm-ss")
    $fileName  = Split-Path $SourceFile -Leaf
    $backupName = "$($fileName).$timestamp.bak"

    $dest = Join-Path $BackupDir $backupName

    # Copy
    Copy-Item -Path $SourceFile -Destination $dest -Force

    Write-Host "Backup created: $dest"
}
catch {
    Write-Error $_
}
