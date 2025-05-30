# Neovim directories to clean up
$NVIM_DIRS = @(
    "$env:USERPROFILE\.config\nvim"
    "$env:USERPROFILE\.local\share\nvim"
    "$env:USERPROFILE\.cache\nvim"
)

# Export variables
$env:NVIM_DIRS = $NVIM_DIRS -join " "

# Add Neovim to PATH if not already present
$nvimPath = "C:\Program Files\Neovim\bin"
if (-not $env:Path.Contains($nvimPath)) {
    $env:Path = "$nvimPath;$env:Path"
}

# Verify installation
Write-Host "Verifying Neovim installation..."
try {
    $output = nvim --version 2>&1
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to verify Neovim installation: $output"
    }
    Write-Host "Neovim version: $($output[0])"
} catch {
    Write-Error "Failed to verify Neovim installation: $_"
    exit 1
}
