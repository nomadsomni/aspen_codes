param(
  [int]$Port = 8080,
  [string]$Page = 'TERMINAL.html',
  [switch]$OpenCastDialog,
  [switch]$Cast,
  [switch]$StartMinimized
)

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$path = Join-Path $root $Page
if (-not (Test-Path $path)) {
  Write-Error "File not found: $path"
}

# Start a tiny static server in the background (ignore if port already in use).
$js = @"
const http=require('http'),fs=require('fs'),path=require('path');
const port=process.env.PORT||${Port};
const root=process.cwd();
const mime={'.html':'text/html','.js':'text/javascript','.css':'text/css','.png':'image/png','.jpg':'image/jpeg','.jpeg':'image/jpeg','.svg':'image/svg+xml','.json':'application/json'};
http.createServer((req,res)=>{
  let u=decodeURIComponent(req.url.split('?')[0]);
  if(u==='/'||u==='')u='/${Page}';
  let fp=path.join(root,u);
  fs.readFile(fp,(err,data)=>{
    if(err){res.statusCode=404;return res.end('Not found');}
    const ext=path.extname(fp).toLowerCase();
    if(mime[ext]) res.setHeader('Content-Type', mime[ext]);
    res.end(data);
  });
}).listen(port,()=>console.log('server',port));
"@

$env:PORT = $Port
try {
  Start-Process -WindowStyle Hidden -FilePath "node" -ArgumentList @("-e", $js) | Out-Null
} catch {
  # If node isn't available or port is already in use, we'll still try to open the page.
}

# Open Edge to the page
$edgeArgs = @("--new-window","http://localhost:$Port/$Page")
$edgeWindowStyle = if ($StartMinimized) { "Minimized" } else { "Normal" }
Start-Process -FilePath "msedge" -ArgumentList $edgeArgs -WindowStyle $edgeWindowStyle
Write-Host "Opened Edge fullscreen to http://localhost:$Port/$Page"

if ($Cast) { $OpenCastDialog = $true }

if ($OpenCastDialog) {
  Start-Sleep -Milliseconds 2000
  try {
    $ws = New-Object -ComObject WScript.Shell
    $null = $ws.AppActivate("Microsoft Edge")
    Start-Sleep -Milliseconds 600
    # Force fullscreen (F11), then open Cast dialog via Polish UI access keys
    $ws.SendKeys("{F11}")
    Start-Sleep -Milliseconds 800
    # Retry the menu sequence up to 3 times if it doesn't open
    for ($i = 0; $i -lt 3; $i++) {
      $ws.SendKeys("%f")
      Start-Sleep -Milliseconds 600
      $ws.SendKeys("d")
      Start-Sleep -Milliseconds 600
      $ws.SendKeys("d")
      Start-Sleep -Milliseconds 600
      $ws.SendKeys("{ENTER}")
      Start-Sleep -Milliseconds 600
      $ws.SendKeys("e")
      Start-Sleep -Milliseconds 600
      $ws.SendKeys("{ENTER}")
      Start-Sleep -Milliseconds 600
    }
  } catch {
    Write-Host "Failed to open Cast dialog automatically. Use Edge menu: ... > More tools > Cast media to device"
  }
} else {
  Write-Host "To cast: Edge menu -> More tools -> Cast media to device -> Cast tab -> SWTV-20AE-PRO"
}
