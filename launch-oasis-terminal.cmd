@echo off
setlocal

set "ROOT=C:\Users\Surface\OneDrive\SIRENSSD"
set "TITLE=oasis @ nomad"

where pwsh >nul 2>nul
if %ERRORLEVEL%==0 (
    start "" pwsh -NoExit -Command "$host.UI.RawUI.WindowTitle = '%TITLE%'; Set-Location '%ROOT%'"
    exit /b 0
)

start "" powershell.exe -NoExit -Command "$host.UI.RawUI.WindowTitle = '%TITLE%'; Set-Location '%ROOT%'"
