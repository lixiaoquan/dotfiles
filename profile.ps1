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

# ---- Linux command equivalents ----

# realpath: resolve to absolute path (non-existent paths allowed, like realpath -m)
function realpath {
    param([Parameter(Mandatory, Position=0, ValueFromRemainingArguments)][string[]]$Path)
    foreach ($p in $Path) {
        if (Test-Path -LiteralPath $p) {
            (Resolve-Path -LiteralPath $p).Path
        }
        elseif ([System.IO.Path]::IsPathRooted($p)) {
            [System.IO.Path]::GetFullPath($p)
        }
        else {
            [System.IO.Path]::GetFullPath((Join-Path (Get-Location).Path $p))
        }
    }
}

# which: show what a command resolves to
function which {
    param([Parameter(Mandatory, Position=0)][string]$Name)
    Get-Command $Name
}

# touch: create empty file, or update timestamp if it exists
function touch {
    param([Parameter(Mandatory, Position=0, ValueFromRemainingArguments)][string[]]$File)
    foreach ($f in $File) {
        if (Test-Path -LiteralPath $f) {
            (Get-Item -LiteralPath $f).LastWriteTime = Get-Date
        }
        else {
            New-Item -ItemType File -Path $f | Out-Null
        }
    }
}

# head: first n lines ("head file" / "head -n 5 file" / "head file 5")
function head {
    param(
        [Parameter(Position=0)][string]$File,
        [Parameter(Position=1)][int]$n = 10
    )
    Get-Content $File -TotalCount $n
}

# tail: last n lines ("tail file" / "tail -n 50 file" / "tail -f file" follows)
function tail {
    param(
        [Parameter(Position=0)][string]$File,
        [Parameter(Position=1)][int]$n = 10,
        [switch]$f
    )
    Get-Content $File -Tail $n -Wait:$f
}