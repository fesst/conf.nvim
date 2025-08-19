#!/bin/bash
set -e

# Homebrew packages
BREW_PACKAGES=(
    "fzf"     # Required for telescope
    "ripgrep" # Required for telescope live grep
    "fd"      # Required for telescope find_files
    "llvm"    # Required for some language servers
    # "cmake"         # Required for building some language servers
    # "delve"         # Required for Go debugging
    "git"
    # "gcc"
    # "make"
    "pkg-config"
    # "php"
    # "composer"
    "luarocks" # Required for Lua package management
    # "postgresql"    # Required for PostgreSQL support
    # "pgformatter"   # Required for PostgreSQL formatting
    "shellcheck"  # Required for shell script linting
    "shfmt"       # Required for shell script formatting
    "tree-sitter" # Required for Treesitter CLI
)

# Homebrew casks
BREW_CASKS=(
    "mactex" # Required for LaTeX support (includes GUI tools)
    "skim"   # Required for PDF viewing
)

# Export variables
export BREW_PACKAGES
export BREW_CASKS

# Install Homebrew packages
for package in "${BREW_PACKAGES[@]}"; do
    brew install "$package"
done
