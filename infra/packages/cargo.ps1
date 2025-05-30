$ErrorActionPreference = 'Stop'

# Cargo packages
$CARGO_PACKAGES = @(
    "stylua"        # Required for Lua formatting
)

# Export variables
$env:CARGO_PACKAGES = $CARGO_PACKAGES

# Ensure cargo is in PATH
if (Test-Path "$env:USERPROFILE\.cargo\env.ps1") {
    . "$env:USERPROFILE\.cargo\env.ps1"
}

# Add cargo bin to PATH if not already present
$cargoBinPath = "$env:USERPROFILE\.cargo\bin"
if ($env:Path -notlike "*$cargoBinPath*") {
    $env:Path = "$cargoBinPath;$env:Path"
}

# Check if we should install stylua
if ($env:INSTALL_STYLUA -ne "false") {
    # Install each package
    foreach ($package in $CARGO_PACKAGES) {
        Write-Host "Installing $package..."
        try {
            $output = cargo install $package --verbose 2>&1
            if ($LASTEXITCODE -ne 0) {
                Write-Host "Failed to install $package. Retrying with --force..."
                $output = cargo install $package --force --verbose 2>&1
                if ($LASTEXITCODE -ne 0) {
                    throw "Failed to install $package even with --force: $output"
                }
            }
        }
        catch {
            Write-Error "Error: Failed to install $package"
            Write-Error "Current PATH: $env:Path"
            Write-Error "Cargo bin location: $cargoBinPath"
            Write-Error "Listing cargo bin directory:"
            Get-ChildItem $cargoBinPath | Format-Table -AutoSize
            throw
        }
    }

    # Verify installations
    foreach ($package in $CARGO_PACKAGES) {
        if (-not (Get-Command $package -ErrorAction SilentlyContinue)) {
            Write-Error "Error: $package installation failed or not found in PATH"
            Write-Error "Current PATH: $env:Path"
            Write-Error "Cargo bin location: $cargoBinPath"
            Write-Error "Listing cargo bin directory:"
            Get-ChildItem $cargoBinPath | Format-Table -AutoSize
            exit 1
        }
        Write-Host "$package installed successfully at $(Get-Command $package).Source"
    }
}
else {
    Write-Host "Skipping stylua installation as INSTALL_STYLUA is set to false"
}
