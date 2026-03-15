$NVIM_DIRS = @(
    "$env:USERPROFILE\.config\nvim"
    "$env:USERPROFILE\.local\share\nvim"
    "$env:USERPROFILE\.cache\nvim"
)

$env:NVIM_DIRS = $NVIM_DIRS -join " "

$nvimPaths = @(
    "C:\Program Files\Neovim\bin",
    "C:\tools\neovim\nvim-win64\bin"
)

foreach ($nvimPath in $nvimPaths) {
    if ((Test-Path $nvimPath) -and ($env:Path -notlike "*$nvimPath*")) {
        $env:Path = "$nvimPath;$env:Path"
    }
}

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

Write-Host "Syncing Neovim plugins..."
nvim --headless "+Lazy! restore" "+qa"
if ($LASTEXITCODE -ne 0) {
    Write-Error "Failed to sync Neovim plugins"
    exit 1
}
