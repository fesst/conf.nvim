# infra/ci-setup-windows.ps1

$ErrorActionPreference = 'Stop'

# Function to check if a package is installed
function Test-ChocolateyPackage {
    param($PackageName)
    $package = choco list --local-only --exact $PackageName
    return $package -match "^$PackageName\s"
}

# Install Chocolatey if not present
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Chocolatey..."
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

Import-Module $env:ChocolateyInstall\helpers\chocolateyProfile.psm1
refreshenv

# Install Neovim and tree-sitter only if not already installed
$packages = @(
    @{Name = "neovim"; Installed = $false}
    @{Name = "tree-sitter-cli"; Installed = $false}
)

foreach ($package in $packages) {
    if (-not (Test-ChocolateyPackage $package.Name)) {
        Write-Host "Installing $($package.Name)..."
        $output = choco install $package.Name -y 2>&1
        if ($LASTEXITCODE -ne 0) {
            throw "Failed to install $($package.Name): ${output}"
        }
    } else {
        Write-Host "$($package.Name) is already installed"
    }
}
refreshenv

# Add Neovim to PATH - try multiple possible locations
$nvimPaths = @(
    "C:\Program Files\Neovim\bin",
    "C:\tools\neovim\nvim-win64\bin"
)

$nvimFound = $false
foreach ($path in $nvimPaths) {
    if (Test-Path $path) {
        if ($env:Path -notlike "*$path*") {
            $env:Path = "$path;$env:Path"
        }
        $nvimFound = $true
        Write-Host "Added Neovim to PATH: $path"
        break
    }
}

if (-not $nvimFound) {
    throw "Neovim installation not found in expected locations"
}

# Add tree-sitter to PATH - try multiple possible locations
$treeSitterPaths = @(
    "C:\Program Files\tree-sitter-cli\bin",
    "C:\tools\tree-sitter-cli\bin",
    "C:\ProgramData\chocolatey\lib\tree-sitter-cli\tools\bin",
    "C:\ProgramData\chocolatey\bin"
)

$treeSitterFound = $false
foreach ($path in $treeSitterPaths) {
    if (Test-Path $path) {
        if ($env:Path -notlike "*$path*") {
            $env:Path = "$path;$env:Path"
        }
        $treeSitterFound = $true
        Write-Host "Added tree-sitter to PATH: $path"
        break
    }
}

if (-not $treeSitterFound) {
    Write-Host "Warning: tree-sitter not found in expected locations. Checking Chocolatey installation directory..."
    $chocoPath = "C:\ProgramData\chocolatey\lib\tree-sitter-cli"
    if (Test-Path $chocoPath) {
        Get-ChildItem -Path $chocoPath -Recurse -Filter "tree-sitter.exe" | ForEach-Object {
            $binPath = Split-Path $_.FullName -Parent
            if ($env:Path -notlike "*$binPath*") {
                $env:Path = "$binPath;$env:Path"
                $treeSitterFound = $true
                Write-Host "Added tree-sitter to PATH: $binPath"
            }
        }
    }
}

# Install tree-sitter parsers
if ($treeSitterFound) {
    Write-Host "Installing tree-sitter parsers..."
    $parsers = @("lua", "python", "vim", "vimdoc")
    foreach ($parser in $parsers) {
        Write-Host "Installing $parser parser..."
        tree-sitter init $parser
    }
} else {
    Write-Host "Warning: tree-sitter not found in PATH. Some functionality may be limited."
}

# Verify Neovim installation
if (-not (Get-Command nvim -ErrorAction SilentlyContinue)) {
    throw "Neovim not found in PATH after installation. Current PATH: ${env:Path}"
}

Write-Host "Neovim version: $(nvim --version)"

# Install Python if not already installed
if (-not (Test-ChocolateyPackage "python312")) {
    Write-Host "Installing Python..."
    $output = choco install python312 -y 2>&1
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to install Python: ${output}"
    }
} else {
    Write-Host "Python is already installed"
}
refreshenv

# Verify Python installation
if (-not (Get-Command python -ErrorAction SilentlyContinue)) {
    throw "Python not found in PATH after installation. Current PATH: ${env:Path}"
}

# Install Node.js if not already installed
if (-not (Test-ChocolateyPackage "nodejs")) {
    Write-Host "Installing Node.js..."
    $output = choco install nodejs -y 2>&1
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to install Node.js: ${output}"
    }
} else {
    Write-Host "Node.js is already installed"
}
refreshenv

# Verify Node.js installation
if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    throw "Node.js not found in PATH after installation. Current PATH: ${env:Path}"
}

# Install Rust if not already installed
if (-not (Test-ChocolateyPackage "rust")) {
    Write-Host "Installing Rust..."
    $output = choco install rust -y 2>&1
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to install Rust: ${output}"
    }
} else {
    Write-Host "Rust is already installed"
}
refreshenv

# Verify Rust installation
if (-not (Get-Command rustc -ErrorAction SilentlyContinue)) {
    throw "Rust not found in PATH after installation. Current PATH: ${env:Path}"
}

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

# Handle virtual environment only if not in CI and not already in a venv
if (-not $env:CI -and -not $env:VIRTUAL_ENV) {
    # Create and activate virtual environment
    $venvPath = Join-Path $PSScriptRoot ".venv"
    if (-not (Test-Path $venvPath)) {
        Write-Host "Creating virtual environment at $venvPath"
        python -m venv $venvPath
    }

    # Activate virtual environment
    $activateScript = Join-Path $venvPath "Scripts\Activate.ps1"
    if (Test-Path $activateScript) {
        Write-Host "Activating virtual environment..."
        . $activateScript
    } else {
        throw "Virtual environment activation script not found at $activateScript"
    }

    # Verify virtual environment activation
    if (-not $env:VIRTUAL_ENV) {
        throw "Failed to activate virtual environment"
    }
} else {
    Write-Host "Skipping virtual environment setup - already in environment or running in CI"
}

Write-Host "Environment setup completed successfully"
