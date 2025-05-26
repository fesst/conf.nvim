# PowerShell script for installing Python packages

# Python packages
$PIP_PACKAGES = @(
    "pynvim"        # Required for Python integration
    "black"         # Required for Python formatting
    "flake8"        # Required for Python linting
    "isort"         # Required for Python import sorting
)

# Install packages
foreach ($package in $PIP_PACKAGES) {
    Write-Output "Installing $package..."
    pip install $package
}
