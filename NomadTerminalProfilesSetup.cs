using System;
using System.Diagnostics;
using System.IO;
using System.Windows.Forms;

internal static class NomadTerminalProfilesSetup
{
    [STAThread]
    private static void Main()
    {
        var baseDir = AppDomain.CurrentDomain.BaseDirectory;
        var packagePath = Path.Combine(baseDir, "Nomad Terminal Profiles.json");

        if (!File.Exists(packagePath))
        {
            MessageBox.Show(
                "Missing profile package:\n" + packagePath,
                "Nomad Terminal Profiles Setup",
                MessageBoxButtons.OK,
                MessageBoxIcon.Error);
            return;
        }

        var tempScript = Path.Combine(Path.GetTempPath(), "nomad-terminal-profiles-install-" + Guid.NewGuid().ToString("N") + ".ps1");

        try
        {
            File.WriteAllText(tempScript, InstallerScript);

            var psi = new ProcessStartInfo
            {
                FileName = "powershell.exe",
                Arguments = "-NoLogo -NoProfile -ExecutionPolicy Bypass -File \"" + tempScript + "\" -PackagePath \"" + packagePath + "\"",
                UseShellExecute = false,
                CreateNoWindow = true,
                RedirectStandardOutput = true,
                RedirectStandardError = true
            };

            using (var process = Process.Start(psi))
            {
                var output = process.StandardOutput.ReadToEnd();
                var error = process.StandardError.ReadToEnd();
                process.WaitForExit();

                if (process.ExitCode != 0)
                {
                    var message = string.IsNullOrWhiteSpace(error) ? output : error;
                    MessageBox.Show(
                        string.IsNullOrWhiteSpace(message) ? "Installation failed." : message,
                        "Nomad Terminal Profiles Setup",
                        MessageBoxButtons.OK,
                        MessageBoxIcon.Error);
                    return;
                }

                MessageBox.Show(
                    string.IsNullOrWhiteSpace(output) ? "Profiles installed." : output,
                    "Nomad Terminal Profiles Setup",
                    MessageBoxButtons.OK,
                    MessageBoxIcon.Information);
            }
        }
        catch (Exception ex)
        {
            MessageBox.Show(
                ex.Message,
                "Nomad Terminal Profiles Setup",
                MessageBoxButtons.OK,
                MessageBoxIcon.Error);
        }
        finally
        {
            try
            {
                if (File.Exists(tempScript))
                {
                    File.Delete(tempScript);
                }
            }
            catch
            {
            }
        }
    }

    private const string InstallerScript = @"
param(
    [Parameter(Mandatory = $true)]
    [string]$PackagePath
)

$ErrorActionPreference = 'Stop'

if (-not (Test-Path $PackagePath)) {
    throw 'Package file not found: ' + $PackagePath
}

function Ensure-ArrayProperty {
    param(
        [Parameter(Mandatory = $true)] $Object,
        [Parameter(Mandatory = $true)] [string]$PropertyName
    )

    $prop = $Object.PSObject.Properties[$PropertyName]
    if (-not $prop -or $null -eq $prop.Value) {
        $Object | Add-Member -NotePropertyName $PropertyName -NotePropertyValue @() -Force
    }
}

function Ensure-ObjectProperty {
    param(
        [Parameter(Mandatory = $true)] $Object,
        [Parameter(Mandatory = $true)] [string]$PropertyName,
        [Parameter(Mandatory = $true)] $Value
    )

    $prop = $Object.PSObject.Properties[$PropertyName]
    if (-not $prop -or $null -eq $prop.Value) {
        $Object | Add-Member -NotePropertyName $PropertyName -NotePropertyValue $Value -Force
    }
}

$settingsCandidates = @(
    (Join-Path $env:LOCALAPPDATA 'Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json'),
    (Join-Path $env:LOCALAPPDATA 'Microsoft\Windows Terminal\settings.json')
)

$settingsPath = $settingsCandidates | Where-Object { Test-Path $_ } | Select-Object -First 1
$createdSettings = $false

if (-not $settingsPath) {
    $settingsPath = $settingsCandidates[0]
    $settingsDir = Split-Path -Parent $settingsPath
    New-Item -ItemType Directory -Path $settingsDir -Force | Out-Null
    $base = [pscustomobject]@{
        '$schema' = 'https://aka.ms/terminal-profiles-schema'
        profiles = [pscustomobject]@{
            defaults = [pscustomobject]@{}
            list = @()
        }
        schemes = @()
    }
    $base | ConvertTo-Json -Depth 100 | Set-Content -LiteralPath $settingsPath -Encoding UTF8
    $createdSettings = $true
}

$backupPath = $null
if (-not $createdSettings) {
    $backupPath = '{0}.{1}.bak' -f $settingsPath, (Get-Date -Format 'yyyyMMdd-HHmmss')
    Copy-Item -LiteralPath $settingsPath -Destination $backupPath -Force
}

$settings = Get-Content -LiteralPath $settingsPath -Raw | ConvertFrom-Json
$package = Get-Content -LiteralPath $PackagePath -Raw | ConvertFrom-Json

Ensure-ObjectProperty -Object $settings -PropertyName 'profiles' -Value ([pscustomobject]@{})
Ensure-ObjectProperty -Object $settings.profiles -PropertyName 'defaults' -Value ([pscustomobject]@{})
Ensure-ArrayProperty -Object $settings.profiles -PropertyName 'list'
Ensure-ArrayProperty -Object $settings -PropertyName 'schemes'

$profileList = @($settings.profiles.list)
$schemeList = @($settings.schemes)

foreach ($scheme in @($package.schemes)) {
    $existingScheme = $schemeList | Where-Object { $_.name -eq $scheme.name } | Select-Object -First 1
    if ($existingScheme) {
        $index = [array]::IndexOf($schemeList, $existingScheme)
        $schemeList[$index] = $scheme
    } else {
        $schemeList += $scheme
    }
}

foreach ($profile in @($package.profiles)) {
    $existingProfile = $profileList | Where-Object { $_.guid -eq $profile.guid -or $_.name -eq $profile.name } | Select-Object -First 1
    if ($existingProfile) {
        $index = [array]::IndexOf($profileList, $existingProfile)
        $profileList[$index] = $profile
    } else {
        $profileList += $profile
    }
}

$settings.profiles.list = $profileList
$settings.schemes = $schemeList
$settings | ConvertTo-Json -Depth 100 | Set-Content -LiteralPath $settingsPath -Encoding UTF8

$lines = @()
$lines += 'Installed terminal package: ' + $PackagePath
$lines += 'Target settings: ' + $settingsPath
if ($backupPath) {
    $lines += 'Backup created: ' + $backupPath
}
$lines += 'Profiles merged: ' + @($package.profiles).Count
$lines += 'Schemes merged: ' + @($package.schemes).Count
$lines -join [Environment]::NewLine
";
}
