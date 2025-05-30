# PowerShell installation script for Neovim configuration
# This script sets up the Neovim environment on Windows using winget (default) or Chocolatey

param(
    [switch]$UseChocolatey
)

# Error handling
$ErrorActionPreference = "Stop"

# Function to check if a command exists
function Test-Command {
    param ($Command)
    $oldPreference = $ErrorActionPreference
    $ErrorActionPreference = 'stop'
    try { if (Get-Command $Command) { return $true } }
    catch { return $false }
    finally { $ErrorActionPreference = $oldPreference }
}

# Function to install Chocolatey if not present
function Install-Chocolatey {
    if (-not (Test-Command choco)) {
        Write-Host "Installing Chocolatey..."
        Set-ExecutionPolicy Bypass -Scope Process -Force
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
        $env:Path = "$env:Path;$env:ChocolateyInstall\bin"
    }
}

# Function to install packages using winget
function Install-WingetPackages {
    Write-Host "Installing system dependencies using winget..."
    winget install --id Microsoft.Python.3.12 --accept-source-agreements --accept-package-agreements
    winget install --id OpenJS.NodeJS.LTS --accept-source-agreements --accept-package-agreements
    winget install --id Git.Git --accept-source-agreements --accept-package-agreements
    winget install --id LLVM.LLVM --accept-source-agreements --accept-package-agreements
    winget install --id BurntSushi.ripgrep --accept-source-agreements --accept-package-agreements
    winget install --id sharkdp.fd --accept-source-agreements --accept-package-agreements
    winget install --id Microsoft.PowerShell --accept-source-agreements --accept-package-agreements
    winget install --id Neovim.Neovim --accept-source-agreements --accept-package-agreements
    winget install --id Microsoft.Tmux --accept-source-agreements --accept-package-agreements
}

# Function to install packages using Chocolatey
function Install-ChocolateyPackages {
    Write-Host "Installing system dependencies using Chocolatey..."
    choco install -y `
        neovim `
        python `
        nodejs `
        git `
        llvm `
        ripgrep `
        fd `
        tmux
}

# Function to install Python packages
function Install-PythonPackages {
    Write-Host "Setting up Python virtual environment..."
    python -m venv .venv
    .\.venv\Scripts\Activate.ps1
    python -m pip install --upgrade pip
    pip install -r requirements.txt
}

# Function to install Node.js packages
function Install-NodePackages {
    Write-Host "Installing Node.js packages..."
    npm install -g typescript-language-server
    npm install -g vscode-langservers-extracted
    npm install -g @tailwindcss/language-server
    npm install -g @typescript-eslint/parser
    npm install -g @typescript-eslint/eslint-plugin
}

# Function to install Rust and related tools
function Install-RustTools {
    Write-Host "Installing Rust and related tools..."
    if (-not (Test-Command rustup)) {
        Invoke-WebRequest -Uri https://win.rustup.rs -OutFile rustup-init.exe
        .\rustup-init.exe -y
        Remove-Item rustup-init.exe
    }
    rustup component add rust-src
    cargo install cargo-watch
}

# Main installation process
try {
    Write-Host "Starting Neovim configuration installation..."

    # Check for winget
    if (-not (Test-Command winget) -and -not $UseChocolatey) {
        Write-Host "winget not found. Installing App Installer..."
        Start-Process "ms-windows-store://pdp/?ProductId=9NBLGGH4NNS1" -Wait
        Write-Host "Please restart your terminal after App Installer is installed and run the script again."
        exit 1
    }

    # Install system dependencies
    if ($UseChocolatey) {
        Install-Chocolatey
        Install-ChocolateyPackages
    } else {
        Install-WingetPackages
    }

    # Refresh environment variables
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

    # Install Python packages
    Install-PythonPackages

    # Install Node.js packages
    Install-NodePackages

    # Install Rust and related tools
    Install-RustTools

    Write-Host "Installation completed successfully!"
} catch {
    Write-Error "An error occurred during installation: $_"
    exit 1
}
