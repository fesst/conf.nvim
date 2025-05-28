$ErrorActionPreference = 'Stop'

# Cargo packages
$CARGO_PACKAGES = @(
    "stylua"        # Required for Lua formatting
)

# Export variables
$env:CARGO_PACKAGES = $CARGO_PACKAGES

# Install packages
foreach ($package in $CARGO_PACKAGES) {
    Write-Output "Installing $package..."
    cargo install $package
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to install $package"
    }
}
