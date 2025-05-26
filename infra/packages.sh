#!/bin/bash
set -e

# Homebrew packages
BREW_PACKAGES=(
    "fzf"           # Required for telescope
    "ripgrep"       # Required for telescope live grep
    "fd"            # Required for telescope find_files
    "llvm"          # Required for some language servers
    "cmake"         # Required for building some language servers
    "delve"         # Required for Go debugging
    "git"
    "gcc"
    "make"
    "pkg-config"
    "php"
    "composer"
    "luarocks"      # Required for Lua package management
    "postgresql"    # Required for PostgreSQL support
    "pgformatter"   # Required for PostgreSQL formatting
    "shellcheck"    # Required for shell script linting
    "shfmt"         # Required for shell script formatting
)

# Homebrew casks
BREW_CASKS=(
    "mactex"        # Required for LaTeX support (includes GUI tools)
    "skim"          # Required for PDF viewing
)

# npm packages
NPM_PACKAGES=(
    "typescript@latest"     # Required for TypeScript language server
    "typescript-language-server@latest"
    "prettier@latest"      # Required for formatting
    "eslint@latest"        # Required for linting
    "@angular/cli@latest"  # Required for Angular development
    "sql-language-server@latest" # Required for SQL support
    "eslint_d@latest"      # Required for null-ls ESLint integration
)

# Add npm configuration to avoid deprecated packages
NPM_CONFIG=(
    "--no-fund"           # Disable funding messages
    "--no-audit"          # Disable audit (we handle this separately)
    "--no-package-lock"   # Don't create package-lock.json for global installs
    "--no-save"           # Don't save to package.json
)

# Python packages
PIP_PACKAGES=(
    "pynvim"        # Required for Python integration
    "black"         # Required for Python formatting
    "flake8"        # Required for Python linting
    "isort"         # Required for Python import sorting
)

# LuaRocks packages
LUAROCKS_PACKAGES=(
    "luacheck"      # Required for Lua linting
)

# Cargo packages
CARGO_PACKAGES=(
    "stylua"        # Required for Lua formatting
)

# Neovim directories to clean up
NVIM_DIRS=(
    "$HOME/.config/nvim"
    "$HOME/.local/share/nvim"
    "$HOME/.cache/nvim"
)

# Export all variables
export BREW_PACKAGES
export BREW_CASKS
export NPM_PACKAGES
export NPM_CONFIG
export PIP_PACKAGES
export LUAROCKS_PACKAGES
export CARGO_PACKAGES
export NVIM_DIRS
