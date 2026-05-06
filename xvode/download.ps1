# Definiowanie tablicy znaków do animacji
$chars = '|','/','-','\'

# Definiowanie maksymalnej wartości paska postępu
$max = 100

# Inicjalizacja paska postępu
$progressBar = @{
    Activity = "Pobieranie..."
    Status = "Postęp:"
    PercentComplete = 0
}

# Wykonanie pętli do wyświetlania animacji
for ($i = 0; $i -le $max; $i++) {
    $progressBar.PercentComplete = $i
    $progressBar.Status = "Postęp: " + $chars[$i % $chars.Length]
    Write-Progress @progressBar
    Start-Sleep -Milliseconds 100
}