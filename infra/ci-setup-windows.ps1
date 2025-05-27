# infra/ci-setup-windows.ps1

# Install Chocolatey if not present
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
  Write-Output "Installing Chocolatey..."
  Set-ExecutionPolicy Bypass -Scope Process -Force
  [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
  Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

Import-Module $env:ChocolateyInstall\helpers\chocolateyProfile.psm1
refreshenv

# Install Neovim and tree-sitter
choco install neovim tree-sitter -y
refreshenv

# Add Neovim to PATH
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
$env:Path = "$env:Path;C:\tools\neovim\nvim-win64\bin"

# Install Python
choco install python312 -y
refreshenv

# Install Node.js
choco install nodejs -y
refreshenv

# Install Rust
choco install rust -y
refreshenv

# Add Cargo to PATH before installing stylua
$env:Path = "$env:Path;$env:USERPROFILE\.cargo\bin"
refreshenv

# Install stylua and verify installation
Write-Output "Installing stylua..."
cargo install stylua --force
refreshenv

# Verify stylua installation
if (-not (Get-Command stylua -ErrorAction SilentlyContinue)) {
    Write-Error "stylua installation failed or not found in PATH"
    exit 1
}

Write-Output "stylua installed successfully at $(Get-Command stylua).Source"
