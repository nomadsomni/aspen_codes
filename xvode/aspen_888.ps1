function xcode($daddy){
    # Read input from the user and store it in the variable $avalanche
    $avalanche = Read-Host -Prompt "Wpisz fraze"
    # Ścieżka do pliku
    $filePath = '.\avalanche.txt'

    # Dodaj wartość $avalanche do pliku
    Add-Content -Path $filePath -Value $avalanche

    # Return the value of $avalanche
    return $avalanche
}

# Wywołaj funkcję xcode z wartością "some value"
$avalanche = xcode "daddy"

# Kontynuuj wywoływanie funkcji xcode, dopóki $avalanche nie będzie równe "end"
while ($avalanche -ne "end") {
    $avalanche = xcode "daddy"
}