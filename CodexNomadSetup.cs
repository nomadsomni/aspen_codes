using System;
using System.Diagnostics;
using System.IO;
using System.Windows.Forms;

internal static class CodexNomadSetup
{
    [STAThread]
    private static void Main()
    {
        var tempScript = Path.Combine(Path.GetTempPath(), "codex-nomad-install-" + Guid.NewGuid().ToString("N") + ".ps1");

        try
        {
            File.WriteAllText(tempScript, InstallerScript);

            var psi = new ProcessStartInfo
            {
                FileName = "powershell.exe",
                Arguments = "-NoLogo -NoProfile -ExecutionPolicy Bypass -File \"" + tempScript + "\"",
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
                        "Codex @ Nomad Setup",
                        MessageBoxButtons.OK,
                        MessageBoxIcon.Error);
                    return;
                }

                MessageBox.Show(
                    string.IsNullOrWhiteSpace(output) ? "Codex @ Nomad installed." : output,
                    "Codex @ Nomad Setup",
                    MessageBoxButtons.OK,
                    MessageBoxIcon.Information);
            }
        }
        catch (Exception ex)
        {
            MessageBox.Show(
                ex.Message,
                "Codex @ Nomad Setup",
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
$ErrorActionPreference = 'Stop'

$installDir = Join-Path $env:LOCALAPPDATA 'CodexNomad'
$launcherPath = Join-Path $installDir 'Codex @ Nomad.cmd'
$profileGuid = '{4c84b3b3-f26e-4d77-b7cb-6ea7a8f74ad5}'
$profileName = 'Codex @ Nomad'
$root = 'C:\Users\Surface\OneDrive\SIRENSSD'
if (-not (Test-Path $root)) {
    $root = $env:USERPROFILE
}

New-Item -ItemType Directory -Path $installDir -Force | Out-Null

$launcher = @'
@echo off
setlocal

set ""ROOT=__ROOT__""
set ""WT_PROFILE={4c84b3b3-f26e-4d77-b7cb-6ea7a8f74ad5}""
set ""TITLE=codex @ nomad""

where wt >nul 2>nul
if %ERRORLEVEL%==0 (
    start """" wt.exe -w new -p ""%WT_PROFILE%""
    exit /b 0
)

where pwsh >nul 2>nul
if %ERRORLEVEL%==0 (
    start """" pwsh -NoExit -Command ""$root = '%ROOT%'; if (-not (Test-Path $root)) { $root = $env:USERPROFILE }; $host.UI.RawUI.WindowTitle = '%TITLE%'; Set-Location $root; if (Get-Command codex -ErrorAction SilentlyContinue) { codex } else { Write-Host 'codex command not found on PATH.' -ForegroundColor Red }""
    exit /b 0
)

start """" powershell.exe -NoExit -Command ""$root = '%ROOT%'; if (-not (Test-Path $root)) { $root = $env:USERPROFILE }; $host.UI.RawUI.WindowTitle = '%TITLE%'; Set-Location $root; if (Get-Command codex -ErrorAction SilentlyContinue) { codex } else { Write-Host 'codex command not found on PATH.' -ForegroundColor Red }""
'@

$launcher = $launcher.Replace('__ROOT__', $root)
Set-Content -LiteralPath $launcherPath -Value $launcher -Encoding ASCII

$settingsCandidates = @(
    (Join-Path $env:LOCALAPPDATA 'Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json'),
    (Join-Path $env:LOCALAPPDATA 'Microsoft\Windows Terminal\settings.json')
)

$settingsPath = $settingsCandidates | Where-Object { Test-Path $_ } | Select-Object -First 1
$backupPath = $null

if ($settingsPath) {
    $backupPath = '{0}.{1}.bak' -f $settingsPath, (Get-Date -Format 'yyyyMMdd-HHmmss')
    Copy-Item -LiteralPath $settingsPath -Destination $backupPath -Force

    $settings = Get-Content -LiteralPath $settingsPath -Raw | ConvertFrom-Json
    $profiles = @($settings.profiles.list)
    $existing = $profiles | Where-Object { $_.guid -eq $profileGuid -or $_.name -eq $profileName } | Select-Object -First 1

    $command = '$root = ''' + $root + '''; if (-not (Test-Path $root)) { $root = $env:USERPROFILE }; Set-Location $root; if (Get-Command codex -ErrorAction SilentlyContinue) { codex } else { Write-Host ''codex command not found on PATH.'' -ForegroundColor Red }'

    if (-not $existing) {
        $newProfile = [pscustomobject]@{
            altGrAliasing = $true
            antialiasingMode = 'grayscale'
            background = '#000000'
            backgroundImageAlignment = 'bottomRight'
            backgroundImageOpacity = 0.42
            bellSound = @('C:\Users\Surface\Downloads\individualities___script .mp3')
            bellStyle = @('audible', 'taskbar')
            closeOnExit = 'automatic'
            colorScheme = '[oasis @ nomad]'
            commandline = 'pwsh.exe -NoExit -Command ""' + $command + '""'
            compatibility = [pscustomobject]@{
                allowDECRQCRA = $true
                input = [pscustomobject]@{
                    forceVT = $true
                }
            }
            cursorShape = 'underscore'
            elevate = $true
            experimental = [pscustomobject]@{
                rainbowSuggestions = $false
                repositionCursorWithMouse = $true
                retroTerminalEffect = $false
            }
            font = [pscustomobject]@{
                face = 'CaskaydiaCove NF'
                features = [pscustomobject]@{}
                size = 7
                weight = 'semi-bold'
            }
            foreground = '#139FD7'
            guid = $profileGuid
            hidden = $false
            historySize = 9001
            icon = 'C:\Users\Surface\Downloads\IMG_8358.jpg'
            intenseTextStyle = 'all'
            name = $profileName
            opacity = 80
            padding = '8, 8, 8, 8'
            scrollbarState = 'hidden'
            selectionBackground = '#FF86FA'
            snapOnInput = $true
            startingDirectory = $root
            suppressApplicationTitle = $false
            tabTitle = $profileName
            useAcrylic = $false
        }

        $settings.profiles.list += $newProfile
        $settings | ConvertTo-Json -Depth 100 | Set-Content -LiteralPath $settingsPath -Encoding UTF8
    }
}

$desktopDir = [Environment]::GetFolderPath('Desktop')
$shortcutPath = Join-Path $desktopDir 'Codex @ Nomad.lnk'
$ws = New-Object -ComObject WScript.Shell
$shortcut = $ws.CreateShortcut($shortcutPath)
$shortcut.TargetPath = $launcherPath
$shortcut.WorkingDirectory = $installDir
$shortcut.Description = 'Open Codex terminal at nomad'
$shortcut.Save()

$lines = @()
$lines += 'Installed launcher: ' + $launcherPath
$lines += 'Desktop shortcut: ' + $shortcutPath
if ($settingsPath) {
    $lines += 'Windows Terminal settings: ' + $settingsPath
    if ($backupPath) {
        $lines += 'Backup created: ' + $backupPath
    }
} else {
    $lines += 'Windows Terminal settings were not found. The launcher still works with shell fallback.'
}

$lines -join [Environment]::NewLine
";
}
