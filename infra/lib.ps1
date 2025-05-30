# PowerShell library script for common functions

# Colors for output (CI-aware)
$CI = if ($env:CI) { $env:CI } else { "false" }
if ($CI -ne "true") {
    $RED = "`e[0;31m"
    $GREEN = "`e[0;32m"
    $YELLOW = "`e[1;33m"
    $NC = "`e[0m" # No Color
}
else {
    $RED = ""
    $GREEN = ""
    $YELLOW = ""
    $NC = ""
}

# Function to print status messages
function Write-Status {
    param([string]$Message)
    Write-Host "$GREEN[+]$NC $Message"
}

function Write-Warning {
    param([string]$Message)
    Write-Host "$YELLOW[!]$NC $Message"
}

function Write-Error {
    param([string]$Message)
    Write-Host "$RED[x]$NC $Message"
}

# Function to check if running on Windows
function Test-Windows {
    if ($env:OS -ne "Windows_NT") {
        Write-Error "This script is currently only supported on Windows"
        exit 1
    }
}

# Function to check if Chocolatey is installed
function Test-Chocolatey {
    if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
        Write-Error "Chocolatey is not installed. Please install it first from https://chocolatey.org/install"
        exit 1
    }
}

# Generic package check function
function Test-Package {
    param(
        [string]$Type,
        [string]$Package
    )

    switch ($Type) {
        "choco" {
            choco list --local-only $Package | Select-String -Pattern "^$Package\s" -Quiet
        }
        "npm" {
            npm list -g $Package | Select-String -Pattern "^$Package\s" -Quiet
        }
        "pip" {
            python -m pip show $Package | Select-String -Pattern "^Name:\s+$Package$" -Quiet
        }
        "luarocks" {
            luarocks list | Select-String -Pattern "^$Package\s" -Quiet
        }
        "cargo" {
            cargo install --list | Select-String -Pattern "^$Package\s" -Quiet
        }
        default {
            Write-Error "Unknown package type: $Type"
            return $false
        }
    }
}

# Function to check if a command exists
function Test-Command {
    param([string]$Command)
    Get-Command $Command -ErrorAction SilentlyContinue
}

# Function to ensure cargo is in PATH
function Ensure-CargoPath {
    if (Test-Command rustup) {
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "User")
    }
}

# Function to run final checks
function Run-FinalChecks {
    Write-Status "Running final checks..."
    if (-not (Test-Command nvim)) {
        Write-Error "Neovim is not installed. Please install it first."
        exit 1
    }
}

# Generic package management functions
function Manage-Packages {
    param(
        [string]$Action,  # install or uninstall
        [string]$Type,    # package type
        [string[]]$Packages
    )

    $installCmd = $null
    $uninstallCmd = $null

    switch ($Type) {
        "choco" {
            $installCmd = "choco install -y"
            $uninstallCmd = "choco uninstall -y"
        }
        "npm" {
            $installCmd = "npm install -g --loglevel=verbose"
            $uninstallCmd = "npm uninstall -g --loglevel=verbose"
        }
        "pip" {
            if ($CI -eq "true") {
                # In CI, ensure we're using the virtual environment's pip
                if (-not $env:VIRTUAL_ENV) {
                    Write-Error "Virtual environment not activated in CI"
                    exit 1
                }
                $installCmd = "$env:VIRTUAL_ENV\Scripts\pip install --quiet"
                $uninstallCmd = "$env:VIRTUAL_ENV\Scripts\pip uninstall -y"
            }
            else {
                $installCmd = "python -m pip install --quiet"
                $uninstallCmd = "python -m pip uninstall -y"
            }
        }
        "luarocks" {
            $installCmd = "luarocks install"
            $uninstallCmd = "luarocks remove"
        }
        "cargo" {
            $installCmd = "cargo install"
            $uninstallCmd = "cargo uninstall"
        }
        default {
            Write-Error "Unknown package type: $Type"
            return
        }
    }

    if ($Action -eq "install") {
        if ($CI -eq "true") {
            Invoke-Expression "$installCmd $Packages"
        }
        else {
            foreach ($package in $Packages) {
                if (-not (Test-Package $Type $package)) {
                    Write-Status "Installing $package..."
                    Invoke-Expression "$installCmd $package"
                }
                else {
                    Write-Warning "$package is already installed"
                }
            }
        }
    }
    elseif ($Action -eq "uninstall") {
        foreach ($package in $Packages) {
            if (Test-Package $Type $package) {
                Write-Status "Uninstalling $package..."
                Invoke-Expression "$uninstallCmd $package"
            }
            else {
                Write-Warning "$package is not installed"
            }
        }
    }
    else {
        Write-Error "Unknown action: $Action"
    }
}

# Convenience functions for backward compatibility
function Install-ChocoPackages {
    param([string[]]$Packages)
    Manage-Packages "install" "choco" $Packages
}

function Install-NpmPackages {
    param([string[]]$Packages)
    Manage-Packages "install" "npm" $Packages
}

function Install-CargoPackages {
    param([string[]]$Packages)
    Manage-Packages "install" "cargo" $Packages
}

function Install-PipPackages {
    param([string[]]$Packages)
    Manage-Packages "install" "pip" $Packages
}

function Install-LuaRocksPackages {
    param([string[]]$Packages)
    Manage-Packages "install" "luarocks" $Packages
}

function Uninstall-ChocoPackages {
    param([string[]]$Packages)
    Manage-Packages "uninstall" "choco" $Packages
}

function Uninstall-NpmPackages {
    param([string[]]$Packages)
    Manage-Packages "uninstall" "npm" $Packages
}

function Uninstall-CargoPackages {
    param([string[]]$Packages)
    Manage-Packages "uninstall" "cargo" $Packages
}

function Uninstall-PipPackages {
    param([string[]]$Packages)
    Manage-Packages "uninstall" "pip" $Packages
}

function Uninstall-LuaRocksPackages {
    param([string[]]$Packages)
    Manage-Packages "uninstall" "luarocks" $Packages
}

# Export all functions
Export-ModuleMember -Function *
