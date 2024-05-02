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
        $wordWithIP = "SANDBOX :: '$word' $ip"

        Write-Output $wordWithIP
        Start-Sleep -Milliseconds 500
    }
}