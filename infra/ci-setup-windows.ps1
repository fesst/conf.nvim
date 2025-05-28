# infra/ci-setup-windows.ps1

$ErrorActionPreference = 'Stop'

# Install Chocolatey if not present
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Chocolatey..."
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

Import-Module $env:ChocolateyInstall\helpers\chocolateyProfile.psm1
refreshenv

# Install Neovim and tree-sitter
Write-Host "Installing Neovim and tree-sitter..."
$output = choco install neovim tree-sitter -y 2>&1
if ($LASTEXITCODE -ne 0) {
    throw "Failed to install Neovim and tree-sitter: $output"
}
refreshenv

# Add Neovim to PATH
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
$env:Path = "$env:Path;C:\tools\neovim\nvim-win64\bin"

# Install Python
Write-Host "Installing Python..."
$output = choco install python312 -y 2>&1
if ($LASTEXITCODE -ne 0) {
    throw "Failed to install Python: $output"
}
refreshenv

# Install Node.js
Write-Host "Installing Node.js..."
$output = choco install nodejs -y 2>&1
if ($LASTEXITCODE -ne 0) {
    throw "Failed to install Node.js: $output"
}
refreshenv

# Install Rust
Write-Host "Installing Rust..."
$output = choco install rust -y 2>&1
if ($LASTEXITCODE -ne 0) {
    throw "Failed to install Rust: $output"
}
refreshenv

# Add Cargo to PATH before installing stylua
$env:Path = "$env:Path;$env:USERPROFILE\.cargo\bin"
refreshenv

# Install stylua and verify installation
Write-Host "Installing stylua..."
$output = cargo install stylua --force --verbose 2>&1
if ($LASTEXITCODE -ne 0) {
    throw "Failed to install stylua: $output"
}
refreshenv

# Verify stylua installation
if (-not (Get-Command stylua -ErrorAction SilentlyContinue)) {
    Write-Error "stylua installation failed or not found in PATH"
    exit 1
}

Write-Host "stylua installed successfully at $(Get-Command stylua).Source"
