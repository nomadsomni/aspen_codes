$edge = "msedge.exe"
$url = "https://soundcloud.com/you/likes"

# Open a new (minimized) terminal window that launches Edge in app mode.
$cmd = "$edge --app=$url --new-window"
Start-Process powershell -WindowStyle Minimized -ArgumentList "-NoProfile -Command `"$cmd`""
