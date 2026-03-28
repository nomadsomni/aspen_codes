
function Get-RandomIP {
    return ("{0}.{1}.{2}.{3}" -f (Get-Random -Maximum 255), (Get-Random -Maximum 255), (Get-Random -Maximum 255), (Get-Random -Maximum 255))
}

# Wywołanie funkcji i wyświetlanie przykładowych adresów IP w nieskończonej pętli
while ($true) {
    Write-Output (Get-RandomIP)
    Start-Sleep -Seconds 0.7
}