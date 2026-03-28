Write-Host "Hello, World!"
Write-Host "This is a PowerShell script."
Write-Host "It is a text file with a .ps1 extension."
Write-Host "You can run it by typing 'powershell' in the terminal."
Write-Host "Then, type 'notes.ps1' and press Enter."
Write-Host "You can also run it by typing 'powershell notes.ps1' in the terminal."
Write-Host "This script will display this text in the terminal."
Write-Host "Press any key to continue..."
$host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") | Out-Null
Write-Host "Goodbye, World!"
Write-Host "Press any key to exit..."
$host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") | Out-Null
Pause





    