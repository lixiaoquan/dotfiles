# PowerShell Profile Configuration
# This file is similar to .bashrc for PowerShell

# Set encoding to UTF-8
$OutputEncoding = [console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

# Set PowerShell to use UTF-8 for all operations
[System.Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Custom prompt function (optional)
function prompt {
    $currentPath = (Get-Location).Path
    $hostName = $env:COMPUTERNAME
    $userName = $env:USERNAME
    Write-Host "[$userName@$hostName " -NoNewline -ForegroundColor Green
    Write-Host "$currentPath" -NoNewline -ForegroundColor Blue
    Write-Host "]$ " -NoNewline -ForegroundColor Green
    return " "
}

# Aliases
# Time alias that behaves like Linux 'time' command
function time {
    param(
        [Parameter(Mandatory=$true, ValueFromRemainingArguments=$true)]
        [string[]]$Command
    )
    
    $commandString = $Command -join ' '
    Write-Host "Timing command: $commandString" -ForegroundColor Yellow
    
    $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
    
    try {
        # Execute the command
        if ($Command.Count -eq 1) {
            $result = Invoke-Expression $Command[0]
        } else {
            $result = & $Command[0] $Command[1..($Command.Count-1)]
        }
        
        $stopwatch.Stop()
        
        # Display timing information similar to Linux time
        $elapsed = $stopwatch.Elapsed
        Write-Host "`nreal    $($elapsed.TotalSeconds.ToString("F3"))s" -ForegroundColor Cyan
        Write-Host "user    $($elapsed.TotalSeconds.ToString("F3"))s" -ForegroundColor Cyan
        Write-Host "sys     0.000s" -ForegroundColor Cyan
        
        return $result
    }
    catch {
        $stopwatch.Stop()
        $elapsed = $stopwatch.Elapsed
        Write-Host "`nCommand failed after $($elapsed.TotalSeconds.ToString("F3"))s" -ForegroundColor Red
        Write-Error $_.Exception.Message
    }
}

# Common aliases
Set-Alias -Name ll -Value Get-ChildItem
Set-Alias -Name la -Value Get-ChildItem
Set-Alias -Name grep -Value Select-String

# Directory navigation aliases
function .. { Set-Location .. }
function ... { Set-Location ..\.. }
function .... { Set-Location ..\..\.. }

# Git aliases (if git is available)
if (Get-Command git -ErrorAction SilentlyContinue) {
    function gs { git status }
    function ga { git add $args }
    function gc { git commit $args }
    function gp { git push $args }
    function gl { git log --oneline -10 }
    function gd { git diff $args }
}

# Enhanced ls function with colors (similar to Linux ls -la)
function ls {
    param([string]$Path = ".")
    Get-ChildItem -Path $Path | Format-Table -AutoSize
}

# Function to reload profile
function Reload-Profile {
    . $PROFILE
    Write-Host "PowerShell profile reloaded!" -ForegroundColor Green
}

# Function to edit profile
function Edit-Profile {
    if ($env:EDITOR) {
        & $env:EDITOR $PROFILE
    } else {
        notepad $PROFILE
    }
}

# Welcome message
Write-Host "PowerShell profile loaded successfully!" -ForegroundColor Green
Write-Host "Type 'Get-Help about_profiles' for more information about PowerShell profiles." -ForegroundColor Cyan

# Additional custom functions can be added here
# ...

# Load additional modules if available
$modules = @("PSReadLine", "posh-git")
foreach ($module in $modules) {
    if (Get-Module -ListAvailable -Name $module) {
        Import-Module $module -ErrorAction SilentlyContinue
    }
}

# PSReadLine configuration (if available)
if (Get-Module PSReadLine) {
    # Check if PSReadLine version supports prediction features
    $psReadLineVersion = (Get-Module PSReadLine).Version
    
    # PredictionSource was introduced in PSReadLine 2.1.0
    if ($psReadLineVersion -ge [Version]"2.1.0") {
        try {
            Set-PSReadLineOption -PredictionSource History
        } catch {
            Write-Warning "PredictionSource feature not available in current PSReadLine version"
        }
    }
    
    # These options are available in older versions
    try {
        Set-PSReadLineOption -HistorySearchCursorMovesToEnd
        Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
        Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
    } catch {
        Write-Warning "Some PSReadLine features not available in current version"
    }
}
