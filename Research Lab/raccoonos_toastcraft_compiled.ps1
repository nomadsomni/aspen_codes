# RaccoonOS Full Suite: Summon Protocols + ToastCraft Engine + Menu
# ================================================================
# This script combines:
#  - RaccoonOS initialization
#  - Summon Raccoon Familiar
#  - Summon Excalibur
#  - Asparagus Lance Protocol
#  - ToastCraft Engine
#  - Interactive Menu

Write-Host "Initializing RaccoonOS Complete Suite..." -ForegroundColor Cyan

# ----------------------------
# Global Variables
# ----------------------------
$RaccoonOS = @{
    Version = "2.0"
    ChaosLevel = 42
    Elegance = "Asparagus Enhanced"
    Worthiness = $false
}

# ----------------------------
# Helpers
# ----------------------------
function Write-Toast {
    param ([string]$Message)
    Write-Host "🍞 $Message" -ForegroundColor Green
}

function Invoke-Toastify {
    param([string]$Message)
    Write-Host "🥑 Toastify >> $Message" -ForegroundColor Green
}

# ----------------------------
# Summon Raccoon Familiar
# ----------------------------
function Invoke-RaccoonSummon {
    Write-Host "🦝 Summoning Raccoon Familiar..." -ForegroundColor Yellow
@"
    (\\__/)
    (•ㅅ•)  <  Raccoon operational.
   / 　 づ
"@ | Write-Host -ForegroundColor White

    $RaccoonOS.Worthiness = $true
    Invoke-Toastify "Raccoon Familiar Online"
}

# ----------------------------
# Summon Excalibur
# ----------------------------
function Invoke-ExcaliburSummon {
    if (-not $RaccoonOS.Worthiness) {
        Write-Host "⚠️  Access Denied. Summon Raccoon First." -ForegroundColor Red
        return
    }

    Write-Host "🗡️ Summoning Excalibur..." -ForegroundColor Magenta
@"
        /\\
       /  \\
 _____/____\\_____
|   Raccoon Excal  |
|       MK II      |
 \\      |||      /
  \\     |||     /
   \\    |||    /
    \\________/
"@ | Write-Host -ForegroundColor Yellow

    Invoke-Toastify "Excalibur Summoned"
}

# ----------------------------
# Asparagus Lance
# ----------------------------
function Invoke-AsparagusLance {
    Write-Host "🥷🥒 Loading Asparagus Lance Protocol..." -ForegroundColor Green
@"
   ////////
  ////////   < Asparagus of the Nine Realms
 ////////
"@ | Write-Host -ForegroundColor Green

    Invoke-Toastify "Asparagus Lance Ready"
}

# ----------------------------
# ToastCraft Engine
# ----------------------------
function New-ToastBase {
    param(
        [ValidateSet("Light","Golden","Burnt","Chaos")]
        [string]$Level = "Golden"
    )

    switch ($Level) {
        "Light"  { $shade = "[ lightly toasted ]" }
        "Golden" { $shade = "[ golden perfect toast ]" }
        "Burnt"  { $shade = "[ charred emotional toast ]" }
        "Chaos"  { $shade = "[ ??? the toaster made a choice ]" }
    }

    Write-Toast "Base created: $shade"
    return $shade
}

function Add-ToastTopping {
    param(
        [string]$ToastBase,
        [ValidateSet("Avocado","Asparagus","Runes","ChaosButter","MythicSalt")]
        [string]$Topping = "Avocado"
    )

    Write-Toast "Applying topping: $Topping"
    return "$ToastBase + $Topping"
}

function New-MythicToast {
    param(
        [ValidateSet("Nordic","Cyber","Romantic","CEO","RaccoonChaos")]
        [string]$Style = "RaccoonChaos"
    )

    Write-Host "⚙ Crafting Mythic Toast: $Style" -ForegroundColor Cyan
    $base = New-ToastBase -Level "Golden"

    switch ($Style) {
        "Nordic" {
            $result = Add-ToastTopping -ToastBase $base -Topping "Asparagus"
            $result = "$result + MythicSalt"
        }
        "Cyber" {
            $result = Add-ToastTopping -ToastBase $base -Topping "Runes"
            $result = "$result + ChaosButter"
        }
        "Romantic" {
            $result = Add-ToastTopping -ToastBase $base -Topping "Avocado"
            $result = "$result + 🌹"
        }
        "CEO" {
            $result = Add-ToastTopping -ToastBase $base -Topping "Asparagus"
            $result = "$result + PerformanceReview"
        }
        "RaccoonChaos" {
            $result = Add-ToastTopping -ToastBase $base -Topping "ChaosButter"
            $result = "$result + 🍪"
        }
    }

    Write-Toast "Mythic Toast Crafted!"
    Write-Host "✨ $result ✨" -ForegroundColor Magenta
    return $result
}

# ----------------------------
# MENU
# ----------------------------
function Show-RaccoonMenu {
    Clear-Host
    Write-Host "=============================" -ForegroundColor DarkCyan
    Write-Host "     RaccoonOS Main Menu      " -ForegroundColor Cyan
    Write-Host "=============================" -ForegroundColor DarkCyan
    Write-Host "1) Summon Raccoon Familiar"
    Write-Host "2) Summon Excalibur"
    Write-Host "3) Summon Asparagus Lance"
    Write-Host "4) Craft Mythic Toast"
    Write-Host "5) Exit"
    Write-Host ""

    $choice = Read-Host "Select an option"

    switch ($choice) {
        "1" { Invoke-RaccoonSummon }
        "2" { Invoke-ExcaliburSummon }
        "3" { Invoke-AsparagusLance }
        "4" { New-MythicToast }
        "5" { Write-Host "Exiting RaccoonOS..."; return }
        default { Write-Host "Invalid choice." -ForegroundColor Red }
    }

    Pause
    Show-RaccoonMenu
}

# Run Menu
Show-RaccoonMenu
