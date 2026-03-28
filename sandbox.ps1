$wordCount = 10
$wordLengths = 1..18  # Define a range for word lengths

$random = New-Object System.Random

function Add-RandomUnderscores {
    param (
        [string]$text
    )
    $numUnderscores = Get-Random -Minimum 1 -Maximum 4
    for ($i = 0; $i -lt $numUnderscores; $i++) {
        $pos = Get-Random -Minimum 0 -Maximum ($text.Length - 1)
        $text = $text.Substring(0, $pos) + "_" + $text.Substring($pos)
    }
    return $text
}
x
while ($true) {
    for ($i = 1; $i -le $wordCount; $i++) {
        $wordLength = $wordLengths | Get-Random
        $word = -join (65..90 | Get-Random -Count $wordLength | ForEach-Object { [char]$_ })
        $word = $word.ToUpper()
        $word = Add-RandomUnderscores $word  # Add underscores only to $word

        if ($word.Length -eq 1) {
            continue
        }

        $ip = "{0}.{1}.{2}.{3}" -f $random.Next(256), $random.Next(256), $random.Next(256), $random.Next(256)
        $wordWithIP = "SANDBOX :: $word $ip"

        Write-Host -ForegroundColor Green $wordWithIP
        Start-Sleep -Milliseconds 500
    }
}
