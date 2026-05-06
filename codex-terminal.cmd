@echo off
setlocal

set "ROOT=C:\Users\Surface\OneDrive\SIRENSSD"
set "WT_PROFILE={4c84b3b3-f26e-4d77-b7cb-6ea7a8f74ad5}"
set "TITLE=codex @ nomad"

where wt >nul 2>nul
if %ERRORLEVEL%==0 (
    start "" wt.exe -w new -p "%WT_PROFILE%"
    exit /b 0
)

where pwsh >nul 2>nul
if %ERRORLEVEL%==0 (
    start "" pwsh -NoExit -Command "$host.UI.RawUI.WindowTitle = '%TITLE%'; Set-Location '%ROOT%'; if (Get-Command codex -ErrorAction SilentlyContinue) { codex } else { Write-Host 'codex command not found on PATH.' -ForegroundColor Red }"
    exit /b 0
)

start "" powershell.exe -NoExit -Command "$host.UI.RawUI.WindowTitle = '%TITLE%'; Set-Location '%ROOT%'; if (Get-Command codex -ErrorAction SilentlyContinue) { codex } else { Write-Host 'codex command not found on PATH.' -ForegroundColor Red }"
