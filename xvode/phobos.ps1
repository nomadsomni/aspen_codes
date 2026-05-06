# Ścieżka do folderu ze zdjęciami
$folderPath = Read-Host 'Wybierz folder'
# Pobierz wszystkie pliki .jpg i .png z folderu
$images = Get-ChildItem -Path $folderPath -Include *.jpg,*.png -Recurse

# Otwórz każde zdjęcie
foreach ($image in $images) {
    Start-Process -FilePath $image.FullName
}