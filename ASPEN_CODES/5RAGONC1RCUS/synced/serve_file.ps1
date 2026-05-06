param(
  [string]$FilePath = "C:\Users\Surface\OneDrive\SIRENSSD\ASPEN_CODES\5RAGONC1RCUS\desynced\iphone_tower.html",
  [int]$Port = 8000
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path $FilePath)) {
  Write-Host "File not found: $FilePath"
  exit 1
}

$listener = New-Object System.Net.HttpListener
$prefix = "http://*:$Port/"
$listener.Prefixes.Add($prefix)

try {
  $listener.Start()
} catch {
  Write-Host "Failed to start listener on $prefix. Try running as Administrator or choose a different port."
  throw
}

$fileName = [System.IO.Path]::GetFileName($FilePath)
Write-Host "Serving $FilePath"
Write-Host "Download URL: http://<THIS_PC_IP>:$Port/$fileName"
Write-Host "Press Ctrl+C to stop."

while ($listener.IsListening) {
  $context = $listener.GetContext()
  $request = $context.Request
  $response = $context.Response

  if ($request.HttpMethod -ne "GET") {
    $response.StatusCode = 405
    $response.Close()
    continue
  }

  $requested = $request.Url.AbsolutePath.TrimStart('/')
  if ($requested -ne $fileName -and $requested -ne "") {
    $response.StatusCode = 404
    $response.Close()
    continue
  }

  $bytes = [System.IO.File]::ReadAllBytes($FilePath)
  $ext = [System.IO.Path]::GetExtension($FilePath).ToLowerInvariant()
  switch ($ext) {
    ".html" { $response.ContentType = "text/html; charset=utf-8" }
    ".htm"  { $response.ContentType = "text/html; charset=utf-8" }
    ".js"   { $response.ContentType = "application/javascript; charset=utf-8" }
    ".css"  { $response.ContentType = "text/css; charset=utf-8" }
    default { $response.ContentType = "application/octet-stream" }
  }
  $response.AddHeader('Content-Disposition', ('attachment; filename="{0}"' -f $fileName))
  $response.ContentLength64 = $bytes.Length
  $response.OutputStream.Write($bytes, 0, $bytes.Length)
  $response.OutputStream.Close()
}
