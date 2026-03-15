$ErrorActionPreference = 'Stop'

$NPM_PACKAGES = @(
    "typescript@latest"
    "typescript-language-server@latest"
    "prettier@latest"
    "eslint@latest"
    "@angular/cli@latest"
    "eslint_d@latest"
)

$NPM_CONFIG = @(
    "--no-audit"
    "--no-fund"
    "--no-package-lock"
    "--no-save"
    "--prefer-offline"
    "--progress=false"
)

$env:NPM_PACKAGES = $NPM_PACKAGES
$env:NPM_CONFIG = $NPM_CONFIG

foreach ($package in $NPM_PACKAGES) {
    $normalizedPackage = if ($package.Contains('@')) { $package.Substring(0, $package.LastIndexOf('@')) } else { $package }
    $installed = npm list -g --depth=0 $normalizedPackage 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Output "npm package already installed: $normalizedPackage"
        continue
    }

    Write-Output "Installing $package..."
    npm install -g $package @NPM_CONFIG
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to install $package"
    }
}
