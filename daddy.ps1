Write-Host "Ustal hasło"
$daddy = Read-Host
Write-Host "Podaj hasło"
$haslo = Read-Host
if ($haslo -eq $daddy) {
    
function Get-RandomIP {
    return ("{0}.{1}.{2}.{3}" -f (Get-Random -Maximum 255), (Get-Random -Maximum 255), (Get-Random -Maximum 255), (Get-Random -Maximum 255))
}

# Wywołanie funkcji i wyświetlanie przykładowych adresów IP w nieskończonej pętli
while ($true) {
    Write-Output (Get-RandomIP)
    Start-Sleep -Seconds 0.7
}# Tutaj umieść kod, który ma być wykonany, gdy hasło jest poprawne
    Write-Host "Hasło poprawne! Skrypt zostanie wykonany."
} else {
    Write-Host "Hasło niepoprawne! Skrypt nie zostanie wykonany."
}