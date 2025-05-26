#!/bin/bash
set -e

# Neovim directories to clean up
NVIM_DIRS=(
    "$HOME/.config/nvim"
    "$HOME/.local/share/nvim"
    "$HOME/.cache/nvim"
)

# Export variables
export NVIM_DIRS
