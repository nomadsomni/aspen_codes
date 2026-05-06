# Ścieżka do pliku
$filePath = Read-Host "Wybierz plik"

# Wczytanie zawartości pliku
$content = Get-Content -Path $filePath

# Wyświetlenie zawartości pliku
Write-Output $content