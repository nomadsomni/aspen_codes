$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$html = Join-Path $root "complex_build.html"

if(-not (Test-Path $html)){
  Write-Host "Missing file: $html"
  exit 1
}

# Open the HTML in the default browser (non-blocking)
Start-Process $html | Out-Null

function Write-UI {
  param(
    [double]$t
  )
  $sync = [Math]::Sin($t * 0.9) * 0.5 + 0.5
  $throughput = (0.6 + 0.4 * $sync) * 100
  $latency = 14 + (1.0 - $sync) * 8
  $util = 40 + 35 * (0.5 + 0.5 * [Math]::Sin($t * 0.7 + 0.6))
  $phase = [Math]::Round($sync * 100)

  $bus = [Math]::Round(90 + 10*$sync)
  $uplink = [Math]::Round(70 + 20*[Math]::Sin($t*0.6 + 0.4))
  $traffic = [Math]::Round($util)

  $esc = [char]27
  $clear = "$esc[2J$esc[H"

  $lines = @()
  $lines += "5RAGONC1RCUS // COMPLEX BUILD"
  $lines += "STATUS: synced $phase% - traffic $traffic% - throughput {0}% - latency {1}ms" -f ([Math]::Round($throughput)), ([Math]::Round($latency,1))
  $lines += ""
  $lines += "OS CONSOLE // TRANSPARENT"
  $lines += "boot: ok"
  $lines += ("bus: {0}%" -f $bus)
  $lines += ("uplink: {0}%" -f $uplink)
  $lines += ("traffic: {0}%" -f $traffic)
  $lines += "kernel: cirrus-5"
  $lines += ""
  $lines += "Press Ctrl+C to stop."

  Write-Host -NoNewline ($clear + ($lines -join "`n"))
}

$start = Get-Date
try {
  while ($true) {
    $t = (Get-Date) - $start
    Write-UI -t $t.TotalSeconds
    Start-Sleep -Milliseconds 100
  }
} catch {
  Write-Host ""
  Write-Host "Exiting."
}
