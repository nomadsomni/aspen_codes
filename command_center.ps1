
# CYBERPUNK MATRIX COMMAND CENTER
# Press CTRL+C to exit

$Host.UI.RawUI.CursorSize = 1
Clear-Host

$width  = $Host.UI.RawUI.WindowSize.Width
$height = $Host.UI.RawUI.WindowSize.Height

$columns = @()
for ($i=0; $i -lt $width; $i++) {
    $columns += Get-Random -Minimum 0 -Maximum $height
}

function Get-CPU {
    (Get-Counter '\Processor(_Total)\% Processor Time').CounterSamples.CookedValue
}

function Get-RAM {
    (Get-Counter '\Memory\Available MBytes').CounterSamples.CookedValue
}

function Get-NET {
    (Get-Counter '\Network Interface(*)\Bytes Total/sec').CounterSamples |
    Measure-Object -Property CookedValue -Sum |
    Select-Object -ExpandProperty Sum
}

function Draw-Stats {

    $cpu  = [math]::Round((Get-CPU),1)
    $ram  = Get-RAM
    $net  = [math]::Round((Get-NET)/1kb,1)
    $time = Get-Date -Format "HH:mm:ss"

    $host.UI.RawUI.CursorPosition = @{X=0;Y=0}
    Write-Host " CYBERPUNK MATRIX NODE " -ForegroundColor Cyan

    $host.UI.RawUI.CursorPosition = @{X=0;Y=1}
    Write-Host " CPU : $cpu %" -ForegroundColor Magenta

    $host.UI.RawUI.CursorPosition = @{X=0;Y=2}
    Write-Host " RAM : $ram MB free" -ForegroundColor Cyan

    $host.UI.RawUI.CursorPosition = @{X=0;Y=3}
    Write-Host " NET : $net KB/s" -ForegroundColor Yellow

    $host.UI.RawUI.CursorPosition = @{X=0;Y=4}
    Write-Host " TIME: $time" -ForegroundColor Green
}

while ($true) {

    for ($i=0; $i -lt $width; $i++) {

        $y = $columns[$i]

        $char = [char](Get-Random -Minimum 33 -Maximum 126)

        $colorRoll = Get-Random -Minimum 0 -Maximum 10

        if ($colorRoll -lt 6) { $color = "DarkGreen" }
        elseif ($colorRoll -lt 8) { $color = "Green" }
        elseif ($colorRoll -eq 8) { $color = "Cyan" }
        else { $color = "Magenta" }

        $host.UI.RawUI.CursorPosition = @{X=$i;Y=$y}
        Write-Host $char -ForegroundColor $color -NoNewline

        $columns[$i] = ($y + 1) % $height
    }

    Draw-Stats

    Start-Sleep -Milliseconds 20
}
