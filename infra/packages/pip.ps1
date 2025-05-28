# PowerShell script for installing Python packages

$ErrorActionPreference = 'Stop'

# Python packages
$PIP_PACKAGES = @(
    "pynvim"        # Required for Python integration
    "black"         # Required for Python formatting
    "flake8"        # Required for Python linting
    "isort"         # Required for Python import sorting
)

# Export variables
$env:PIP_PACKAGES = $PIP_PACKAGES

# Install packages
foreach ($package in $PIP_PACKAGES) {
    Write-Output "Installing $package..."
    pip install $package
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to install $package"
    }
}
