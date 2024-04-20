# BEGIN: Test-GenerateRandomIPAddresses
function Test-GenerateRandomIPAddresses {
    param (
        [Parameter(Mandatory=$true)]
        [string[]]$ipAddresses
    )

    Describe "Generate random IP addresses" {
        Context "When IP addresses are provided" {
            It "Should write IP addresses to a file" {
                # Arrange
                $expectedFilePath = "ip_addresses.txt"

                # Act
                $ipAddresses | Out-File -FilePath $expectedFilePath

                # Assert
                $actualContent = Get-Content -Path $expectedFilePath
                $expectedContent = $ipAddresses -join "`r`n"
                $actualContent | Should -Be $expectedContent
            }
        }
    }
}

# Invoke the test
Test-GenerateRandomIPAddresses -ipAddresses @("192.168.0.1", "10.0.0.1", "172.16.0.1")
# END: Test-GenerateRandomIPAddresses