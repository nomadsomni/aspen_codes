
# MATRIX ULTIMATE TERMINAL
# Works in Windows Terminal / PowerShell
# Press CTRL+C to stop

$Host.UI.RawUI.CursorSize = 1
$width = $Host.UI.RawUI.WindowSize.Width
$height = $Host.UI.RawUI.WindowSize.Height

$columns = @()
for ($i = 0; $i -lt $width; $i++) {
    $columns += Get-Random -Minimum 0 -Maximum $height
}

function Get-CPU {
    (Get-Counter '\Processor(_Total)\% Processor Time').CounterSamples.CookedValue
}

function Get-RAM {
    (Get-Counter '\Memory\Available MBytes').CounterSamples.CookedValue
}

Clear-Host

while ($true) {

    # draw matrix rain
    for ($i = 0; $i -lt $width; $i++) {

        $y = $columns[$i]

        $char = [char](Get-Random -Minimum 33 -Maximum 126)

        $host.UI.RawUI.CursorPosition = @{X=$i;Y=$y}
        Write-Host $char -ForegroundColor Green -NoNewline

        $columns[$i] = ($y + 1) % $height
    }

    # system overlay (top left)
    $cpu = [math]::Round((Get-CPU),1)
    $ram = Get-RAM
    $time = Get-Date -Format "HH:mm:ss"

    $host.UI.RawUI.CursorPosition = @{X=0;Y=0}
    Write-Host " MATRIX NODE ACTIVE " -ForegroundColor Cyan

    $host.UI.RawUI.CursorPosition = @{X=0;Y=1}
    Write-Host " CPU  : $cpu %" -ForegroundColor DarkGreen

    $host.UI.RawUI.CursorPosition = @{X=0;Y=2}
    Write-Host " RAM  : $ram MB free" -ForegroundColor DarkGreen

    $host.UI.RawUI.CursorPosition = @{X=0;Y=3}
    Write-Host " TIME : $time" -ForegroundColor DarkGreen

    Start-Sleep -Milliseconds 25
}
