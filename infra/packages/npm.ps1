# PowerShell script for installing npm packages

$ErrorActionPreference = 'Stop'

# NPM packages
$NPM_PACKAGES = @(
    "typescript@latest"     # Required for TypeScript language server
    "typescript-language-server@latest"
    "prettier@latest"      # Required for formatting
    "eslint@latest"        # Required for linting
    "@angular/cli@latest"  # Required for Angular development
    "sql-language-server@latest" # Required for SQL support
    "eslint_d@latest"      # Required for null-ls ESLint integration
)

# Add npm configuration to optimize caching and installation
$NPM_CONFIG = @(
    "--no-fund"           # Disable funding messages
    "--no-audit"          # Disable audit (we handle this separately)
    "--no-package-lock"   # Don't create package-lock.json for global installs
    "--no-save"           # Don't save to package.json
    "--prefer-offline"    # Use cached packages when possible
    "--progress=false"    # Disable progress bar for cleaner logs
)

# Export variables
$env:NPM_PACKAGES = $NPM_PACKAGES
$env:NPM_CONFIG = $NPM_CONFIG

# Install packages
foreach ($package in $NPM_PACKAGES) {
    Write-Output "Installing $package..."
    npm install -g $package $NPM_CONFIG
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to install $package"
    }
}
