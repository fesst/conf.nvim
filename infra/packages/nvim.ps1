# Neovim directories to clean up
$NVIM_DIRS = @(
    "$env:USERPROFILE\.config\nvim"
    "$env:USERPROFILE\.local\share\nvim"
    "$env:USERPROFILE\.cache\nvim"
)

# Export variables
$env:NVIM_DIRS = $NVIM_DIRS -join " "
