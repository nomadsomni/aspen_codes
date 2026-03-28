# TRUE INSANE MATRIX TERMINAL
# CTRL + C to exit

Clear-Host
$Host.UI.RawUI.CursorSize = 1

$bootLines = @(
    "INITIALIZING CORE SYSTEMS",
    "LOADING NEURAL BUS",
    "SYNCING I/O MATRIX",
    "CALIBRATING SENSORS",
    "ESTABLISHING UPLINK",
    "FINALIZING BOOT SEQUENCE"
)

Clear-Host
foreach ($line in $bootLines) {
    Write-Host "$line..." -ForegroundColor Cyan
    Start-Sleep -Milliseconds (Get-Random -Minimum 120 -Maximum 260)
}
Start-Sleep -Milliseconds 200
Clear-Host

$useRawUI = $true
try {
    $null = $Host.UI.RawUI.WindowSize.Width
} catch {
    $useRawUI = $false
}

function Get-WindowSize {
    if (-not $useRawUI) {
        return [pscustomobject]@{ Width = 120; Height = 40 }
    } else {
        $raw = $Host.UI.RawUI
        return [pscustomobject]@{
            Width  = $raw.WindowSize.Width
            Height = $raw.WindowSize.Height
        }
    }
}

function Set-CursorSafe {
    param(
        [int]$X,
        [int]$Y
    )
    if (-not $useRawUI) { return $false }
    if ($X -lt 0 -or $Y -lt 0) { return $false }
    if ($X -ge $width -or $Y -ge $height) { return $false }
    try {
        $host.UI.RawUI.CursorPosition = @{X=$X;Y=$Y}
    } catch {
        return $false
    }
    return $true
}

$size = Get-WindowSize
$width  = $size.Width
$height = $size.Height

$columns = @()
for ($i=0; $i -lt $width; $i++) {
    $columns += Get-Random -Minimum 0 -Maximum $height
}

function GetCPU {
    try {
        (Get-Counter '\Processor(_Total)\% Processor Time' -ErrorAction Stop 2>$null).CounterSamples.CookedValue
    } catch {
        try {
            (Get-CimInstance Win32_Processor -ErrorAction Stop | Measure-Object -Property LoadPercentage -Average).Average
        } catch {
            $null
        }
    }
}

function GetRAM {
    try {
        (Get-Counter '\Memory\Available MBytes' -ErrorAction Stop 2>$null).CounterSamples.CookedValue
    } catch {
        try {
            $os = Get-CimInstance Win32_OperatingSystem -ErrorAction Stop
            [math]::Round($os.FreePhysicalMemory / 1024)
        } catch {
            $null
        }
    }
}

function GetNET {
    try {
        (Get-Counter '\Network Interface(*)\Bytes Total/sec' -ErrorAction Stop 2>$null).CounterSamples |
        Measure-Object -Property CookedValue -Sum |
        Select-Object -ExpandProperty Sum
    } catch {
        try {
            $adapters = Get-NetAdapterStatistics -ErrorAction Stop
            $rx = ($adapters | Measure-Object -Property ReceivedBytes -Sum).Sum
            $tx = ($adapters | Measure-Object -Property SentBytes -Sum).Sum
            ($rx + $tx)
        } catch {
            $null
        }
    }
}

function RandomIP {
    "$(Get-Random -Minimum 1 -Maximum 255).$(Get-Random -Minimum 1 -Maximum 255).$(Get-Random -Minimum 1 -Maximum 255).$(Get-Random -Minimum 1 -Maximum 255)"
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
    if ($height -lt 5 -or $width -lt 1) { return }

    $cpuVal = GetCPU
    $ramVal = GetRAM
    $netVal = GetNET

    $cpu = if ($null -ne $cpuVal) { [math]::Round($cpuVal,1) } else { "N/A" }
    $ram = if ($null -ne $ramVal) { $ramVal } else { "N/A" }
    $net = if ($null -ne $netVal) { [math]::Round(($netVal)/1kb,1) } else { "N/A" }
    $time = Get-Date -Format "HH:mm:ss"

    if (Set-CursorSafe -X 0 -Y 0) { Write-Host " CYBER COMMAND NODE " -ForegroundColor Cyan }

    if (Set-CursorSafe -X 0 -Y 1) { Write-Host " CPU : $cpu %" -ForegroundColor Green }

    if (Set-CursorSafe -X 0 -Y 2) { Write-Host " RAM : $ram MB FREE" -ForegroundColor Green }

    if (Set-CursorSafe -X 0 -Y 3) { Write-Host " NET : $net KB/s" -ForegroundColor Yellow }

    if (Set-CursorSafe -X 0 -Y 4) { Write-Host " TIME: $time" -ForegroundColor Magenta }
}

function DrawHackLog {
    if ($height -lt 8 -or $width -lt 1) { return }
    for ($i=0;$i -lt 6;$i++) {
        $y = 7 + $i
        if (-not (Set-CursorSafe -X 0 -Y $y)) { continue }

        $ip = RandomIP
        $action = FakeHackLine

        Write-Host "$ip  ->  $action" -ForegroundColor DarkGreen
    }
}

while ($true) {
    $newSize = Get-WindowSize
    if ($newSize.Width -ne $width -or $newSize.Height -ne $height) {
        $width  = $newSize.Width
        $height = $newSize.Height
        $columns = @()
        for ($i=0; $i -lt $width; $i++) {
            $columns += Get-Random -Minimum 0 -Maximum $height
        }
        Clear-Host
    }

    if (-not $useRawUI) {
        Clear-Host
        $cpuVal = GetCPU
        $ramVal = GetRAM
        $netVal = GetNET

        $cpu = if ($null -ne $cpuVal) { [math]::Round($cpuVal,1) } else { "N/A" }
        $ram = if ($null -ne $ramVal) { $ramVal } else { "N/A" }
        $net = if ($null -ne $netVal) { [math]::Round(($netVal)/1kb,1) } else { "N/A" }
        $time = Get-Date -Format "HH:mm:ss"

        Write-Host " CYBER COMMAND NODE " -ForegroundColor Cyan
        Write-Host " CPU : $cpu %" -ForegroundColor Green
        Write-Host " RAM : $ram MB FREE" -ForegroundColor Green
        Write-Host " NET : $net KB/s" -ForegroundColor Yellow
        Write-Host " TIME: $time" -ForegroundColor Magenta
        Write-Host ""
        for ($i=0; $i -lt 6; $i++) {
            $ip = RandomIP
            $action = FakeHackLine
            Write-Host "$ip  ->  $action" -ForegroundColor DarkGreen
        }
        Start-Sleep -Milliseconds 250
        continue
    }

    DrawStats
    DrawHackLog

    Start-Sleep -Milliseconds 25
}
