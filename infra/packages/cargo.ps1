$ErrorActionPreference = 'Stop'

# Cargo packages
$CARGO_PACKAGES = @(
    "stylua"        # Required for Lua formatting
)

# Export variables
$env:CARGO_PACKAGES = $CARGO_PACKAGES

# Function to check if a package is installed
function Test-CargoPackage {
    param($PackageName)
    $installed = cargo install --list | Select-String "^$PackageName\s"
    return $installed -ne $null
}

# Install packages
foreach ($package in $CARGO_PACKAGES) {
    if (-not (Test-CargoPackage $package)) {
        Write-Host "Installing $package..."
        $output = cargo install $package --verbose 2>&1
        if ($LASTEXITCODE -ne 0) {
            throw "Failed to install ${package}: ${output}"
        }
    } else {
        Write-Host "$package is already installed"
    }
}
