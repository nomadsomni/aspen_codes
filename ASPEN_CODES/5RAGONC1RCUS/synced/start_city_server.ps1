$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$serve = Join-Path $root "serve_file.ps1"
$file = Join-Path $root "city_network.html"

powershell -ExecutionPolicy Bypass -File $serve -FilePath $file -Port 8027
