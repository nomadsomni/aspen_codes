# ==========================================
# RaccoonOS v5.1 — Ultimate Chaos Neon Edition
# Paste this into your $PROFILE
# ==========================================

# -------------------------
# Basic environment / prompt
# -------------------------
if ($IsLinux) { $Username = $(whoami) } else { $Username = $env:USERNAME }
$host.ui.RawUI.WindowTitle = "$Username @ $(hostname)"

function prompt {
    Write-Host -NoNewline -ForegroundColor Yellow "`n➤ "
    return " "
}

# -------------------------
# Logging
# -------------------------
$LogFile = "$env:USERPROFILE\Documents\aspen_codes\$(Get-Date -Format 'yyyy-MM-dd').log"
if (-not (Test-Path $LogFile)) {
    New-Item -ItemType Directory -Path (Split-Path $LogFile) -ErrorAction SilentlyContinue | Out-Null
}
function Write-PSLog { param([string]$Message)
    Add-Content -Path $LogFile -Value "[$((Get-Date).ToString('HH:mm:ss'))] $Message"
}
Write-PSLog "RaccoonOS v5.1 Neon session launched"

# -------------------------
# Core state
# -------------------------
$RaccoonOS = @{
    Version    = "5.1-Neon"
    ChaosLevel = 42
    Worthiness = $false
    Admin      = $false
}

# -------------------------
# Helpers: output, sound
# -------------------------
function Write-Toast {
    param([string]$Msg)
    Write-Host "🍞 $Msg" -ForegroundColor Green
}

function Invoke-Toastify {
    param([string]$Msg)
    Write-Host "🥑 Toastify >> $Msg" -ForegroundColor Green
}

function Invoke-RaccoonSound {
    param(
        [ValidateSet("ping","alert","toast","magic","drumroll")]$Type = "ping"
    )
    switch ($Type) {
        "ping"     { Write-Host "`a" -NoNewline }
        "alert"    { Write-Host "🔔 DING!" -ForegroundColor Yellow }
        "toast"    { Write-Host "🍞 *tsssshhhhh*" -ForegroundColor DarkYellow }
        "magic"    { Write-Host "✨ *woooosh*" -ForegroundColor Magenta }
        "drumroll" {
            for ($i = 0; $i -lt 3; $i++) {
                Write-Host -NoNewline "."
                Start-Sleep -Milliseconds 200
            }
            Write-Host "🥁"
        }
    }
}

# -------------------------
# Hyper-Premium Neon Animation Engine (Global)
# -------------------------
function Invoke-RaccoonAnimation {
    param(
        [string]$Text = "Booting RaccoonOS",
        [int]$SpeedMs = 140,
        [int]$Loops   = 1,
        [int]$Glow    = 3   # Higher = thicker neon aura
    )

    # Core frames
    $frames = @(
        "        (\__/)        ",
        "        (•ㅅ•)        ",
        "    (•ㅅ•)  $Text     ",
        "        (•ㅅ•)        ",
        "        (\__/)        "
    )

    # Neon color cycle — cyberpunk pulse
    $neonCycle = @(
        "Cyan", "Magenta", "Blue", "DarkCyan", "DarkMagenta"
    )

    # Fixed height to guarantee clean wipe
    $blockHeight = 9

    for ($loop = 0; $loop -lt $Loops; $loop++) {
        foreach ($f in $frames) {
            Clear-Host

            # Dynamic neon header pulse
            $headerColor = $neonCycle[(Get-Random -Minimum 0 -Maximum $neonCycle.Count)]
            $bar = "=" * 40

            Write-Host $bar -ForegroundColor $headerColor
            Write-Host ("      RaccoonOS v5.1 — {0}" -f $Text) -ForegroundColor $headerColor
            Write-Host $bar -ForegroundColor $headerColor
            Write-Host ""

            # Neon aura layers
            for ($g = $Glow; $g -gt 0; $g--) {
                $pad = 6 - $g
                if ($pad -lt 0) { $pad = 0 }
                Write-Host (" " * $pad) $f -ForegroundColor $headerColor
            }

            # Core bright sprite
            Write-Host (" " * 4) $f -ForegroundColor White

            # Pad out remaining height so previous frames can't leak
            $usedLines = $Glow + 1  # glow layers + core line
            for ($padLine = 0; $padLine -lt ($blockHeight - $usedLines); $padLine++) {
                Write-Host " "
            }

            Start-Sleep -Milliseconds $SpeedMs
        }
    }
}

# -------------------------
# Long intro splash (session start)
# -------------------------
function Show-IntroSplash {
    Invoke-RaccoonAnimation -Text "Initializing Mythic Breakfast" -SpeedMs 150 -Loops 2 -Glow 4
    Invoke-RaccoonSound magic
    Write-Host ""
    Write-Host "Welcome, Neon CEO of Chaos — RaccoonOS v5.1 loaded." -ForegroundColor Green
    Start-Sleep -Milliseconds 400
}

# -------------------------
# Asparagus patch (safe)
# -------------------------
function Invoke-AsparaHack {
    param(
        [switch]$Override,
        [switch]$Wisdom,
        [switch]$Elegance
    )
    Invoke-RaccoonAnimation -Text "Asparagus Subsystem" -SpeedMs 80 -Loops 1 -Glow 2
    Write-Host "🥷🥒 Initializing Asparagus Lance Subsystem..." -ForegroundColor Cyan
    if ($Override) { Write-Host "⚡ Override enabled." -ForegroundColor Yellow }
    if ($Wisdom)   { Write-Host "📡 Wisdom Patch Applied (+10 clarity)." -ForegroundColor DarkGreen }
    if ($Elegance) { Write-Host "💅 Elegance Mode Active." -ForegroundColor Magenta }
    Invoke-RaccoonSound toast
    Invoke-Toastify "Asparagus Subsystem Ready."
}

# -------------------------
# Summons
# -------------------------
function Invoke-RaccoonSummon {
    Invoke-RaccoonAnimation -Text "Summoning Neon Familiar" -SpeedMs 120 -Loops 1 -Glow 4
    Invoke-RaccoonSound magic
@"
 (\__/) 
 (•ㅅ•)  <  Neon raccoon operational.
 / 　 づ
"@ | Write-Host -ForegroundColor White
    $RaccoonOS.Worthiness = $true
    Invoke-Toastify "Raccoon Familiar Online (Neon Mode)"
}

# Excalibur: CEO Edition (admin required)
function Invoke-ExcaliburCEO {
    if (-not $RaccoonOS.Admin) {
        Write-Host "⚠️  Admin required. Enter ADMIN mode (menu option) first." -ForegroundColor Red
        return
    }
    Invoke-RaccoonAnimation -Text "Excalibur: CEO Edition" -SpeedMs 110 -Loops 1 -Glow 5
    Invoke-RaccoonSound drumroll
@"
         /\
        /  \
   ____/____\____
  |   EXCALIBUR   |
  |  CEO EDITION  |
   \    |||     /
    \   |||    /
     \  |||   /
      \______/ 
"@ | Write-Host -ForegroundColor Yellow
    Write-Host "⚜️  CEO Excalibur Overdrive engaged — Grants executive neon toast privileges." -ForegroundColor Magenta
    $RaccoonOS.ChaosLevel = [math]::Min(999, $RaccoonOS.ChaosLevel + 200)
    Invoke-Toastify "Excalibur CEO summoned (Neon Overdrive)."
}

function Invoke-AsparagusLance {
    Invoke-RaccoonAnimation -Text "Asparagus Lance Online" -SpeedMs 90 -Loops 1 -Glow 3
    Write-Host "🥷🥒 Loading Asparagus Lance..." -ForegroundColor Green
@"
 ////////
 ////////   < Asparagus of the Nine Realms (Neon)
 ////////
"@ | Write-Host -ForegroundColor Green
    Invoke-RaccoonSound magic
    Invoke-Toastify "Asparagus Lance Ready (Glowing)."
}

# -------------------------
# ToastCraft Extras: Randomized Toast of the Day
# -------------------------
$__ToastBank = @(
    @{name="Nordic Asparagus"; style="Nordic"; desc="Asparagus + MythicSalt — Viking-level brunch."},
    @{name="Cyber Runes"; style="Cyber"; desc="Runes + ChaosButter — neon glitch breakfast."},
    @{name="Romantic Avocado"; style="Romantic"; desc="Avocado + rose — dangerously poetic."},
    @{name="CEO Performance"; style="CEO"; desc="Asparagus + PerformanceReview — efficient and crisp."},
    @{name="RaccoonChaos"; style="RaccoonChaos"; desc="ChaosButter + Cookie — comfort and chaos."}
)

function Get-RandomToastOfTheDay {
    # Deterministic-ish per day
    $seed = [int](Get-Date -UFormat %j) + (Get-Date).Year
    $rand = New-Object System.Random($seed)
    $idx  = $rand.Next(0, $__ToastBank.Count)
    return $__ToastBank[$idx]
}

function Show-ToastOfTheDay {
    $t = Get-RandomToastOfTheDay
    Invoke-RaccoonAnimation -Text "Toast of the Day" -SpeedMs 90 -Loops 1 -Glow 2
    Write-Host "🍞 Toast of the Day: $($t.name) — $($t.desc)" -ForegroundColor Magenta
    Write-Host "Craft command: New-MythicToast -Style $($t.style)" -ForegroundColor DarkGray
}

# -------------------------
# ToastCraft core
# -------------------------
function New-ToastBase {
    param(
        [ValidateSet("Light","Golden","Burnt","Chaos")]$Level = "Golden"
    )
    $shade = switch ($Level) {
        "Light" { "[ lightly toasted ]" }
        "Golden" { "[ golden perfect toast ]" }
        "Burnt" { "[ charred emotional toast ]" }
        default { "[ ??? the toaster made a choice ]" }
    }
    Write-Toast "Base created: $shade"
    return $shade
}

function Add-ToastTopping {
    param(
        [string]$ToastBase,
        [ValidateSet("Avocado","Asparagus","Runes","ChaosButter","MythicSalt")]$Topping
    )
    Write-Toast "Applying topping: $Topping"
    return "$ToastBase + $Topping"
}

function New-MythicToast {
    param(
        [ValidateSet("Nordic","Cyber","Romantic","CEO","RaccoonChaos")]$Style = "RaccoonChaos"
    )
    Invoke-RaccoonAnimation -Text "Crafting $Style Toast" -SpeedMs 80 -Loops 1 -Glow 2
    Write-Host "⚙ Crafting Mythic Toast: $Style" -ForegroundColor Cyan
    Invoke-RaccoonSound toast
    $base = New-ToastBase -Level Golden
    $result = switch ($Style) {
        "Nordic"       { "$base + Asparagus + MythicSalt" }
        "Cyber"        { "$base + Runes + ChaosButter (Neon Glaze)" }
        "Romantic"     { "$base + Avocado + 🌹" }
        "CEO"          { "$base + Asparagus + PerformanceReview" }
        "RaccoonChaos" { "$base + ChaosButter + 🍪" }
    }
    Write-Toast "Mythic Toast Crafted!"
    Write-Host "✨ $result ✨" -ForegroundColor Magenta
    return $result
}

# -------------------------
# ADMIN MODE v2 — with animation & timed boosts
# -------------------------
function Enter-RaccoonAdminMode {
    Clear-Host
    Invoke-RaccoonAnimation -Text "Authorizing Admin" -SpeedMs 80 -Loops 1 -Glow 4
    Write-Host "🔐 Entering Raccoon Admin Mode v2..." -ForegroundColor Magenta
    Invoke-RaccoonSound alert
    $RaccoonOS.Admin      = $true
    $RaccoonOS.Worthiness = $true
    $RaccoonOS.ChaosLevel = 999
    Write-Host "🦝💼 ADMIN MODE ENABLED. Excalibur CEO functions unlocked." -ForegroundColor Green
    Invoke-Toastify "Administrator privileges active for 60s."
    # Temporary timed overdrive window
    Start-Job -ScriptBlock {
        Start-Sleep -Seconds 60
        $marker = "$env:TEMP\raccoon_admin_marker.tmp"
        New-Item -Path $marker -Force | Out-Null
        Start-Sleep -Milliseconds 100
    } | Out-Null
}

# Utility to check and disable admin if time expired (poller)
function _RaccoonAdminPoll {
    $marker = "$env:TEMP\raccoon_admin_marker.tmp"
    if (Test-Path $marker) {
        Remove-Item $marker -ErrorAction SilentlyContinue
        $RaccoonOS.Admin      = $false
        $RaccoonOS.ChaosLevel = 42
        Write-Host "`n🔒 Admin window expired. Powers scaled back." -ForegroundColor DarkYellow
    }
}

# -------------------------
# Animated Auto-refresh Menu (Neon Edition)
# -------------------------
function Show-RaccoonMenu {
    while ($true) {
        Clear-Host
        Invoke-RaccoonAnimation -Text "RaccoonOS Console" -SpeedMs 90 -Loops 1 -Glow 3

        Write-Host "============ RaccoonOS v5.1 Neon ============" -ForegroundColor DarkCyan
        Write-Host "1) Summon Raccoon Familiar (Neon)"
        Write-Host "2) Summon Excalibur (Admin required)"
        Write-Host "3) Summon Asparagus Lance (Neon)"
        Write-Host "4) Craft Mythic Toast (Neon sequence)"
        Write-Host "5) Show Toast of the Day"
        Write-Host "6) Random Mythic Toast (auto)"
        Write-Host "7) Asparagus Hack Console"
        Write-Host "69) Enter ADMIN MODE v2"
        Write-Host "0) Exit"
        Write-Host ""
        Write-Host "ChaosLevel: $($RaccoonOS.ChaosLevel)   Worthy: $($RaccoonOS.Worthiness)   Admin: $($RaccoonOS.Admin)"
        Write-Host ""
        $choice = Read-Host "Select an option"

        switch ($choice) {
            "1" { Invoke-RaccoonSummon }
            "2" { Invoke-ExcaliburCEO }
            "3" { Invoke-AsparagusLance }
            "4" {
                $style = Read-Host "Style (Nordic/Cyber/Romantic/CEO/RaccoonChaos)"
                if ($style) { New-MythicToast -Style $style } else { Write-Host "Cancelled." }
            }
            "5" { Show-ToastOfTheDay }
            "6" {
                $t = Get-RandomToastOfTheDay
                Write-Host "Auto-crafted toast => $($t.name)" -ForegroundColor Magenta
                New-MythicToast -Style $t.style
            }
            "7" { Invoke-AsparaHack -Wisdom -Elegance }
            "69" { Enter-RaccoonAdminMode }
            "0" {
                Write-Host "Exiting RaccoonOS Neon..." -ForegroundColor DarkCyan
                break
            }
            default { Write-Host "Invalid choice." -ForegroundColor Red }
        }

        # Poll admin expiry marker
        _RaccoonAdminPoll

        Write-Host ""
        Read-Host "Press Enter to continue..."
    }
}

# -------------------------
# Session start: show intro splash then menu
# -------------------------
Show-IntroSplash
Show-RaccoonMenu
