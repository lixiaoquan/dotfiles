# AutoHotkey v2 (portable) setup for Windows
# - Ensures portable AutoHotkey v2 at %LOCALAPPDATA%\Programs\AutoHotkey-v2 (downloads if missing)
# - Associates .ahk with it (user scope, no admin required)
# - (Re)starts the hotkey script dotfiles\ahk\hotkeys.ahk
# No autostart by design; run this script again any time to update or restart.

param(
    [switch]$NoStart,
    [switch]$Help
)

if ($Help) {
    Write-Host @"
AutoHotkey v2 setup

Usage: .\install\ahk.ps1 [-NoStart] [-Help]

Options:
  -NoStart    Set up interpreter and association, but do not (re)start the script
  -Help       Show this help

What it does:
1. Ensures AutoHotkey v2 portable exists at %LOCALAPPDATA%\Programs\AutoHotkey-v2
   (downloads from https://www.autohotkey.com/download/ahk-v2.zip if missing)
2. Associates .ahk with that interpreter (HKCU, no admin required)
3. Stops any running hotkeys.ahk instance and starts dotfiles\ahk\hotkeys.ahk

"@ -ForegroundColor Cyan
    exit 0
}

$ErrorActionPreference = 'Stop'

$DotfilesDir = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$AhkDir     = Join-Path $DotfilesDir 'ahk'
$MainScript = Join-Path $AhkDir 'hotkeys.ahk'
$ExeDir     = Join-Path $env:LOCALAPPDATA 'Programs\AutoHotkey-v2'
$Exe        = Join-Path $ExeDir 'AutoHotkey64.exe'
$ZipUrl     = 'https://www.autohotkey.com/download/ahk-v2.zip'
$ProgId     = 'AutoHotkeyV2.Script'

if (-not (Test-Path $MainScript)) {
    Write-Error "Script not found: $MainScript"
    exit 1
}

# --- 1. Interpreter -----------------------------------------------------------
if (Test-Path $Exe) {
    Write-Host "Interpreter already present: $Exe" -ForegroundColor Green
} else {
    Write-Host "Downloading AutoHotkey v2 portable from $ZipUrl ..." -ForegroundColor Yellow
    [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor 3072
    $Zip = Join-Path $env:TEMP 'ahk-v2.zip'
    Invoke-WebRequest -Uri $ZipUrl -OutFile $Zip -UseBasicParsing
    if ((Get-Item $Zip).Length -lt 1MB) { Write-Error "Downloaded file too small, aborting"; exit 1 }
    Expand-Archive -Path $Zip -DestinationPath $ExeDir -Force
    Remove-Item $Zip -Force
    if (-not (Test-Path $Exe)) { Write-Error "Interpreter missing after extraction: $Exe"; exit 1 }
    Write-Host "Installed interpreter: $Exe" -ForegroundColor Green
}

# --- 2. .ahk association (user scope) -----------------------------------------
$Cmd = '"' + $Exe + '" "%1" %*'

New-Item -Path "HKCU:\Software\Classes\$ProgId\shell\open\command" -Force | Out-Null
Set-ItemProperty -Path "HKCU:\Software\Classes\$ProgId\shell\open\command" -Name '(default)' -Value $Cmd
New-Item -Path "HKCU:\Software\Classes\$ProgId\DefaultIcon" -Force | Out-Null
Set-ItemProperty -Path "HKCU:\Software\Classes\$ProgId\DefaultIcon" -Name '(default)' -Value "$Exe,1"

if (-not (Test-Path 'HKCU:\Software\Classes\.ahk')) {
    New-Item -Path 'HKCU:\Software\Classes\.ahk' -Force | Out-Null
}
Set-ItemProperty -Path 'HKCU:\Software\Classes\.ahk' -Name '(default)' -Value $ProgId

# Windows protects the UserChoice key with a hash, so if an app was already picked
# we repoint that ProgId's open command instead of writing UserChoice directly.
$UserChoicePath = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.ahk\UserChoice'
if (Test-Path $UserChoicePath) {
    $ExistingProgId = (Get-ItemProperty -Path $UserChoicePath).ProgId
    if ($ExistingProgId -and $ExistingProgId -ne $ProgId) {
        $ExistingCmdPath = "HKCU:\Software\Classes\$ExistingProgId\shell\open\command"
        if (-not (Test-Path $ExistingCmdPath)) {
            New-Item -Path $ExistingCmdPath -Force | Out-Null
        }
        Set-ItemProperty -Path $ExistingCmdPath -Name '(default)' -Value $Cmd
        Write-Host "UserChoice ProgId '$ExistingProgId' repointed to the new interpreter" -ForegroundColor Yellow
    }
}

Add-Type -Namespace Win32 -Name ShellNotify -MemberDefinition '[DllImport("shell32.dll")] public static extern void SHChangeNotify(int wEventId, uint uFlags, IntPtr i1, IntPtr i2);'
[Win32.ShellNotify]::SHChangeNotify(0x08000000, 0, [IntPtr]::Zero, [IntPtr]::Zero)
Write-Host ".ahk association -> $Exe" -ForegroundColor Green

# --- 3. (Re)start the hotkey script --------------------------------------------
if ($NoStart) {
    Write-Host "Skipping start (-NoStart)" -ForegroundColor Yellow
    exit 0
}

Get-CimInstance Win32_Process -Filter "Name='AutoHotkey.exe' OR Name='AutoHotkey64.exe'" |
    Where-Object { $_.CommandLine -match 'ahk\\hotkeys\.ahk' } |
    ForEach-Object {
        Write-Host "Stopping old instance (PID $($_.ProcessId))" -ForegroundColor Yellow
        Stop-Process -Id $_.ProcessId -Force
    }

Start-Process -FilePath $Exe -ArgumentList "`"$MainScript`"" -WorkingDirectory $AhkDir
Start-Sleep -Seconds 2
$Running = Get-CimInstance Win32_Process -Filter "Name='AutoHotkey64.exe'" |
    Where-Object { $_.CommandLine -match [regex]::Escape($MainScript) }
if ($Running) {
    Write-Host "Hotkey script running (PID $($Running.ProcessId)): $MainScript" -ForegroundColor Green
} else {
    Write-Error "Script did not stay running: $MainScript"
    exit 1
}
