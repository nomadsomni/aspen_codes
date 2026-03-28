$width = $Host.UI.RawUI.WindowSize.Width
$height = $Host.UI.RawUI.WindowSize.Height

$columns = @()
for ($i=0;$i -lt $width;$i++){ $columns += Get-Random -Maximum $height }

while ($true) {
    for ($i=0;$i -lt $width;$i++) {

        $y = $columns[$i]
        $char = [char](Get-Random 33 126)

        $host.UI.RawUI.CursorPosition = @{X=$i;Y=$y}

        Write-Host $char -ForegroundColor Green -NoNewline

        $columns[$i] = ($y + 1) % $height
    }

    Start-Sleep -Milliseconds 25
}
