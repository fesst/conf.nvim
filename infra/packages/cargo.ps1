$ErrorActionPreference = 'Stop'

# Cargo packages
$CARGO_PACKAGES = @(
    "stylua"        # Required for Lua formatting
)

# Export variables
$env:CARGO_PACKAGES = $CARGO_PACKAGES

# Install packages
foreach ($package in $CARGO_PACKAGES) {
    Write-Host "Installing $package..."
    $output = cargo install $package --verbose 2>&1
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to install $package: $output"
    }
}
