$ErrorActionPreference = 'Stop'

$PIP_PACKAGES = @(
    "black"
    "flake8"
    "isort"
    "pynvim"
    "pytest"
)

$env:PIP_PACKAGES = $PIP_PACKAGES

python -m pip install --upgrade pip
foreach ($package in $PIP_PACKAGES) {
    Write-Host "Installing $package..."
    $output = python -m pip install $package --no-cache-dir --verbose 2>&1
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to install ${package}: ${output}"
    }
}
