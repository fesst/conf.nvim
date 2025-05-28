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
nvim --version
