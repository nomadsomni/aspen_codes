Write-Host "Ustal hasło"
$daddy = Read-Host
Write-Host "Podaj hasło"
$haslo = Read-Host
if ($haslo -eq $daddy) {
    # Tutaj umieść kod, który ma być wykonany, gdy hasło jest poprawne
    Write-Host "Hasło poprawne! Skrypt zostanie wykonany."
} else {
    Write-Host "Hasło niepoprawne! Skrypt nie zostanie wykonany."
}