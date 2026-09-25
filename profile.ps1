# PowerShell Profile Configuration
# This file is similar to .bashrc for PowerShell

# Set encoding to UTF-8
$OutputEncoding = [console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

# Set PowerShell to use UTF-8 for all operations
[System.Console]::OutputEncoding = [System.Text.Encoding]::UTF8

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
        # Execute the command and capture both output and result
        if ($Command.Count -eq 1) {
            $result = Invoke-Expression $Command[0]
        } else {
            $result = & $Command[0] $Command[1..($Command.Count-1)]
        }
        
        $stopwatch.Stop()
        
        # First display the command output/result
        if ($result -ne $null) {
            $result
        }
        
        # Then display timing information similar to Linux time
        $elapsed = $stopwatch.Elapsed
        Write-Host "`nreal    $($elapsed.TotalSeconds.ToString("F3"))s" -ForegroundColor Cyan
        Write-Host "user    $($elapsed.TotalSeconds.ToString("F3"))s" -ForegroundColor Cyan
        Write-Host "sys     0.000s" -ForegroundColor Cyan
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

# Directory navigation aliases
function .. { Set-Location .. }
function ... { Set-Location ..\.. }
function .... { Set-Location ..\..\.. }

# Built-in aliases gc/gp (Get-Content/Get-ItemProperty) outrank functions,
# so our git commit/push shortcuts never worked until these are removed
Remove-Item Alias:gc, Alias:gp -Force -ErrorAction SilentlyContinue

if (Get-Command git -ErrorAction SilentlyContinue) {
    function gs { git status }
    function ga { git add $args }
    function gc { git commit $args }
    function gp { git push $args }
    function gl { git log --oneline -10 }
    function gd { git diff $args }
}

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

# PSReadLine: history search with arrows, Tab menu completion
Set-PSReadLineOption -HistoryNoDuplicates -HistorySearchCursorMovesToEnd
Set-PSReadLineKeyHandler -Key UpArrow   -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineKeyHandler -Key Tab       -Function MenuComplete

# Gray inline prediction from history (needs PSReadLine >= 2.1; PS 5.1 has 2.0 and skips this)
# Also skipped when output is redirected (CI/scripts): console lacks VT processing there
$psrl = Get-Module PSReadLine
if ($psrl -and $psrl.Version -ge [version]'2.1.0' -and -not [Console]::IsOutputRedirected) {
    Set-PSReadLineOption -PredictionSource History -PredictionViewStyle ListView -EditMode Windows
}