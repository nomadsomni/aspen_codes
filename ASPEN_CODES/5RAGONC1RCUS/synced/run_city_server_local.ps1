$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$target = Join-Path $root "start_city_server.ps1"

if (-not (Test-Path $target)) {
  Write-Host "Missing: $target"
  exit 1
}

Start-Process powershell -ArgumentList @("-ExecutionPolicy", "Bypass", "-File", $target)
