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
1. Create symbolic links for PowerShell profile configuration
2. Backup existing profile if it exists
3. Set up the profile.ps1 from this dotfiles repository

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

# Get PowerShell profile paths
$ProfilePaths = @{
    "CurrentUserCurrentHost" = $PROFILE.CurrentUserCurrentHost
    "CurrentUserAllHosts" = $PROFILE.CurrentUserAllHosts
}

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

# Install profile for current user, current host
$Success = $true
$ProfilePath = $ProfilePaths["CurrentUserCurrentHost"]

if ($UseSymLink) {
    $Success = New-SymbolicLink -Target $ProfileSource -Path $ProfilePath -Description "PowerShell Profile (Current User, Current Host)"
} else {
    Write-Host "Copying profile file (no symbolic link)..." -ForegroundColor Yellow
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

Write-Host ""

if ($Success) {
    Write-Host "Installation completed successfully!" -ForegroundColor Green
} else {
    Write-Host "Installation failed!" -ForegroundColor Red
    exit 1
}
