# PowerShell Profile Installation Script
# This script creates symbolic links for PowerShell profile configuration

param(
    [switch]$Force,
    [switch]$Help
)

if ($Help) {
    Write-Host @"
PowerShell Profile Installation Script

Usage: .\install.ps1 [-Force] [-Help]

Options:
  -Force    Force overwrite existing profile files
  -Help     Show this help message

This script will:
1. Link profile.ps1 to BOTH Windows PowerShell 5.1 and PowerShell 7
   profile locations (works no matter which shell runs the script)
2. Create symbolic links, or copy files if not running as Administrator
3. Backup existing profiles if they exist

"@ -ForegroundColor Cyan
    exit 0
}

# Get the script directory (dotfiles directory)
$DotfilesDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ProfileSource = Join-Path $DotfilesDir "profile.ps1"

# Check if source profile exists
if (-not (Test-Path $ProfileSource)) {
    Write-Error "Source profile not found: $ProfileSource"
    exit 1
}

# Link the same profile.ps1 into both Windows PowerShell 5.1 and PowerShell 7
# profile locations, regardless of which shell runs this script
$DocumentsDir = [Environment]::GetFolderPath('MyDocuments')
$InstallTargets = @(
    @{
        Description = "PowerShell Profile 5.1 (Current User, Current Host)"
        Path        = Join-Path $DocumentsDir "WindowsPowerShell\Microsoft.PowerShell_profile.ps1"
    }
    @{
        Description = "PowerShell Profile 7 (Current User, Current Host)"
        Path        = Join-Path $DocumentsDir "PowerShell\Microsoft.PowerShell_profile.ps1"
    }
)

Write-Host "PowerShell Profile Installation" -ForegroundColor Green
Write-Host "================================" -ForegroundColor Green
Write-Host ""

Write-Host "Dotfiles directory: $DotfilesDir" -ForegroundColor Cyan
Write-Host "Source profile: $ProfileSource" -ForegroundColor Cyan
Write-Host ""

# Function to create symbolic link
function New-SymbolicLink {
    param(
        [string]$Target,
        [string]$Path,
        [string]$Description
    )
    
    Write-Host "Setting up $Description..." -ForegroundColor Yellow
    Write-Host "  Target: $Target" -ForegroundColor Gray
    Write-Host "  Link: $Path" -ForegroundColor Gray
    
    # Create directory if it doesn't exist
    $ParentDir = Split-Path -Parent $Path
    if (-not (Test-Path $ParentDir)) {
        Write-Host "  Creating directory: $ParentDir" -ForegroundColor Gray
        New-Item -ItemType Directory -Path $ParentDir -Force | Out-Null
    }
    
    # Already linked to the right source: nothing to do
    if (Test-Path $Path) {
        $Existing = Get-Item $Path
        if ($Existing.LinkType -eq 'SymbolicLink' -and $Existing.Target -eq $Target) {
            Write-Host "  ✓ Already linked correctly, skipping" -ForegroundColor Green
            return $true
        }
    }

    # Handle existing file/link
    if (Test-Path $Path) {
        if ($Force) {
            Write-Host "  Removing existing file/link (forced)" -ForegroundColor Yellow
            Remove-Item $Path -Force
        } else {
            # Create backup
            $BackupPath = "$Path.backup.$(Get-Date -Format 'yyyyMMdd-HHmmss')"
            Write-Host "  Backing up existing file to: $BackupPath" -ForegroundColor Yellow
            Move-Item $Path $BackupPath
        }
    }
    
    # Create symbolic link
    try {
        New-Item -ItemType SymbolicLink -Path $Path -Target $Target -Force | Out-Null
        Write-Host "  ✓ Successfully created symbolic link" -ForegroundColor Green
        return $true
    } catch {
        Write-Error "  ✗ Failed to create symbolic link: $($_.Exception.Message)"
        return $false
    }
}

# Check if running as administrator (required for symbolic links on Windows)
$IsAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")

if (-not $IsAdmin) {
    Write-Warning "This script should be run as Administrator to create symbolic links."
    Write-Host "You can still continue, but the script will copy files instead of creating symbolic links." -ForegroundColor Yellow
    $Response = Read-Host "Continue with file copy? (y/N)"
    if ($Response -ne 'y' -and $Response -ne 'Y') {
        Write-Host "Installation cancelled." -ForegroundColor Red
        exit 1
    }
    $UseSymLink = $false
} else {
    $UseSymLink = $true
}

Write-Host ""

# Install profile for both PowerShell versions
$Success = $true

foreach ($Dest in $InstallTargets) {
    $ProfilePath = $Dest.Path

    if ($UseSymLink) {
        $Result = New-SymbolicLink -Target $ProfileSource -Path $ProfilePath -Description $Dest.Description
        if (-not $Result) { $Success = $false }
    } else {
        Write-Host "Copying profile ($($Dest.Description))..." -ForegroundColor Yellow
        try {
            $ParentDir = Split-Path -Parent $ProfilePath
            if (-not (Test-Path $ParentDir)) {
                New-Item -ItemType Directory -Path $ParentDir -Force | Out-Null
            }

            if (Test-Path $ProfilePath -and -not $Force) {
                $BackupPath = "$ProfilePath.backup.$(Get-Date -Format 'yyyyMMdd-HHmmss')"
                Move-Item $ProfilePath $BackupPath
                Write-Host "  Backed up existing profile to: $BackupPath" -ForegroundColor Yellow
            }

            Copy-Item $ProfileSource $ProfilePath -Force
            Write-Host "  ✓ Successfully copied profile file" -ForegroundColor Green
        } catch {
            Write-Error "  ✗ Failed to copy profile file: $($_.Exception.Message)"
            $Success = $false
        }
    }
}

Write-Host ""

if ($Success) {
    Write-Host "Installation completed successfully!" -ForegroundColor Green
} else {
    Write-Host "Installation failed!" -ForegroundColor Red
    exit 1
}
