# TRUE INSANE MATRIX TERMINAL
# CTRL + C to exit

Clear-Host
$Host.UI.RawUI.CursorSize = 1

$width  = $Host.UI.RawUI.WindowSize.Width
$height = $Host.UI.RawUI.WindowSize.Height
$uiHeight = 15


$columns = @()
for ($i=0; $i -lt $width; $i++) {
    $columns += Get-Random -Minimum 0 -Maximum $height
}

function GetCPU {
    (Get-Counter '\Processor(_Total)\% Processor Time').CounterSamples.CookedValue
}

function GetRAM {
    (Get-Counter '\Memory\Available MBytes').CounterSamples.CookedValue
}

function GetNET {
    (Get-Counter '\Network Interface(*)\Bytes Total/sec').CounterSamples |
    Measure-Object -Property CookedValue -Sum |
    Select-Object -ExpandProperty Sum
}

function RandomIP {
    "$((Get-Random -Minimum 1 -Maximum 255)).$((Get-Random -Minimum 1 -Maximum 255)).$((Get-Random -Minimum 1 -Maximum 255)).$((Get-Random -Minimum 1 -Maximum 255))"
}

function FakeHackLine {

$lines = @(
"Scanning open ports",
"Injecting payload",
"Bypassing firewall",
"Decrypting packet stream",
"Accessing remote node",
"Enumerating devices",
"Bruteforce attempt",
"Intercepting traffic",
"Mapping subnet",
"Uploading exploit"
)

return $lines | Get-Random
}

function DrawStats {

$cpu = [math]::Round((GetCPU),1)
$ram = GetRAM
$net = [math]::Round((GetNET)/1kb,1)
$time = Get-Date -Format "HH:mm:ss"

$host.UI.RawUI.CursorPosition = @{X=0;Y=0}
Write-Host " CYBER COMMAND NODE " -ForegroundColor Cyan

$host.UI.RawUI.CursorPosition = @{X=0;Y=1}
Write-Host " CPU : $cpu %" -ForegroundColor Green

$host.UI.RawUI.CursorPosition = @{X=0;Y=2}
Write-Host " RAM : $ram MB FREE" -ForegroundColor Green

$host.UI.RawUI.CursorPosition = @{X=0;Y=3}
Write-Host " NET : $net KB/s" -ForegroundColor Yellow

$host.UI.RawUI.CursorPosition = @{X=0;Y=4}
Write-Host " TIME: $time" -ForegroundColor Magenta

}

function DrawHackLog {

for ($i=0;$i -lt 6;$i++) {

$y = ($columns[$i] + $uiHeight) % $height
$host.UI.RawUI.CursorPosition = @{X=0;Y=$y}

$ip = RandomIP
$action = FakeHackLine

Write-Host "$ip  ->  $action" -ForegroundColor DarkGreen
}

}

function DrawMatrix {

for ($i=0; $i -lt $width; $i++) {

$y = $columns[$i]

$char = [char](Get-Random -Minimum 33 -Maximum 126)

$colorRoll = Get-Random -Minimum 0 -Maximum 10

if ($colorRoll -lt 6) { $color="DarkGreen" }
elseif ($colorRoll -lt 8) { $color="Green" }
elseif ($colorRoll -eq 8) { $color="Cyan" }
else { $color="Magenta" }

$host.UI.RawUI.CursorPosition = @{X=$i;Y=$y}
Write-Host $char -ForegroundColor $color -NoNewline

$columns[$i] = ($y + 1) % $height

}

}

while ($true) {

DrawMatrix
DrawStats
DrawHackLog

Start-Sleep -Milliseconds 25

}
