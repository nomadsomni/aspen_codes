# Generate random IP addresses
$ipAddresses = 1..10 | ForEach-Object {
    $ip = 1..4 | ForEach-Object { Get-Random -Minimum 1 -Maximum 255 }
    $ip -join '.'
}

# Write IP addresses to a file
$ipAddresses | Out-File -FilePath "ip_addresses.txt"