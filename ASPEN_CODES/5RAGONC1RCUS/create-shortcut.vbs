Set oWS = CreateObject("WScript.Shell")
Set oLink = oWS.CreateShortcut("C:\Users\Surface\OneDrive\Desktop\Terminal Cast.lnk")
oLink.TargetPath = "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"
oLink.Arguments = "-NoProfile -ExecutionPolicy Bypass -File ""C:\Users\Surface\OneDrive\SIRENSSD\ASPEN_CODES\5RAGONC1RCUS\run-terminal-cast.ps1"" -Cast"
oLink.WorkingDirectory = "C:\Users\Surface\OneDrive\SIRENSSD\ASPEN_CODES\5RAGONC1RCUS"
oLink.WindowStyle = 7
oLink.Description = "Run Terminal cast (fullscreen + cast dialog)"
oLink.Hotkey = "Alt+Shift+L"
oLink.Save
