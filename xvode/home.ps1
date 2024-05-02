# Define the menu options
$menuOptions = @{
    "1" = "aspen_codes: SANDBOX#"
    "2" = "Script 2"
    "3" = "Script 3"
    "4" = "Exit"
}

# Display the menu
do {
    Clear-Host
    Write-Host "=== Menu ==="
    $menuOptions.GetEnumerator() | Sort-Object Name | ForEach-Object {
        Write-Host "$($_.Key). $($_.Value)"
    }
    $choice = Read-Host "Enter your choice"
    
    # Execute the selected script
    switch ($choice) {
        "1" {
            # Run Script 1
            Write-Host "Running SANDBOX#..."
            # Add your script code here
            $wordLengths = 2..10
$wordCount = 10

$random = New-Object System.Random

while ($true) {
    for ($i = 1; $i -le $wordCount; $i++) {
        $wordLength = $wordLengths | Get-Random
        $word = -join (65..90 | Get-Random -Count $wordLength | ForEach-Object { [char]$_ })
        $word = $word.ToUpper()

        if ($word.Length -eq 1) {
            continue
        }

        $ip = "{0}.{1}.{2}.{3}" -f $random.Next(256), $random.Next(256), $random.Next(256), $random.Next(256)
        $wordWithIP = "SANDBOX :: $word $ip"

        Write-Output $wordWithIP
        Start-Sleep -Milliseconds 500
    }
}
            Pause
        }
        "2" {
            # Run Script 2
            Write-Host "Running Script 2..."
            # Add your script code here
            Pause
        }
        "3" {
            # Run Script 3
            Write-Host "Running Script 3..."
            # Add your script code here
            Pause
        }
        "4" {
            # Exit the menu
            Write-Host "Exiting..."
            break
        }
        default {
            Write-Host "Invalid choice. Please try again."
            Pause
        }
    }
} while ($choice -ne "4")