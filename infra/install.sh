#!/bin/bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print status messages
print_status() {
    echo -e "${GREEN}[+]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

print_error() {
    echo -e "${RED}[x]${NC} $1"
}

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    print_error "This script is currently only supported on macOS"
    exit 1
fi

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    print_error "Homebrew is not installed. Please install it first from https://brew.sh"
    exit 1
fi

# Install Homebrew packages
print_status "Installing Homebrew packages..."
brew_packages=(
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
)

for package in "${brew_packages[@]}"; do
    if ! brew list "$package" &>/dev/null; then
        print_status "Installing $package..."
        brew install "$package"
    else
        print_warning "$package is already installed"
    fi
done

# Install MacTeX for LaTeX support
print_status "Installing MacTeX for LaTeX support..."
if ! command -v latexmk &> /dev/null; then
    print_status "Installing MacTeX..."
    brew install --cask mactex-no-gui
else
    print_warning "LaTeX is already installed"
fi

# Install Skim for PDF viewing
print_status "Installing Skim for PDF viewing..."
if ! brew list --cask skim &>/dev/null; then
    print_status "Installing Skim..."
    brew install --cask skim
else
    print_warning "Skim is already installed"
fi

# Install Node.js and npm packages
print_status "Installing Node.js and npm packages..."
if ! command -v node &> /dev/null; then
    print_status "Installing Node.js..."
    brew install node
fi

npm_packages=(
    "typescript"     # Required for TypeScript language server
    "typescript-language-server"
    "prettier"      # Required for formatting
    "eslint"        # Required for linting
    "@angular/cli"  # Required for Angular development
)

for package in "${npm_packages[@]}"; do
    if ! npm list -g "$package" &>/dev/null; then
        print_status "Installing $package..."
        npm install -g "$package"
    else
        print_warning "$package is already installed"
    fi
done

# Install Rust and Cargo packages
print_status "Installing Rust and Cargo packages..."
if ! command -v rustc &> /dev/null; then
    print_status "Installing Rust..."
    brew install rust
fi

# Ensure cargo is in PATH regardless of installation method
if command -v rustup &> /dev/null; then
    source "$HOME/.cargo/env"
fi

# Install rust-analyzer through Homebrew
if ! brew list rust-analyzer &>/dev/null; then
    print_status "Installing rust-analyzer..."
    brew install rust-analyzer
else
    print_warning "rust-analyzer is already installed"
fi

# Install lldb through Homebrew
if ! brew list llvm &>/dev/null; then
    print_status "Installing llvm (for lldb)..."
    brew install llvm
else
    print_warning "llvm (lldb) is already installed"
fi

# Install Python packages
print_status "Installing Python packages..."
if ! command -v python3 &> /dev/null; then
    print_status "Installing Python..."
    brew install python
fi

pip_packages=(
    "pynvim"        # Required for Python integration
    "black"         # Required for Python formatting
    "flake8"        # Required for Python linting
)

for package in "${pip_packages[@]}"; do
    if ! python3 -m pip show "$package" &>/dev/null; then
        print_status "Installing $package..."
        python3 -m pip install --quiet "$package"
    else
        print_warning "$package is already installed"
    fi
done

# Install LuaRocks packages
print_status "Installing LuaRocks packages..."
luarocks_packages=(
    "luacheck"      # Required for Lua linting
)

for package in "${luarocks_packages[@]}"; do
    if ! luarocks list | grep -q "^$package "; then
        print_status "Installing $package..."
        luarocks install "$package"
    else
        print_warning "$package is already installed"
    fi
done

# Install stylua for Lua formatting
print_status "Installing stylua for Lua formatting..."
if ! command -v stylua &> /dev/null; then
    print_status "Installing stylua..."
    cargo install stylua
else
    print_warning "stylua is already installed"
fi

# Install CodeLLDB
"$(dirname "$0")/codelldb.sh"

# Final checks
print_status "Running final checks..."
if ! command -v nvim &> /dev/null; then
    print_error "Neovim is not installed. Please install it first."
    exit 1
fi

print_status "Installation completed successfully!"
print_status "Please restart your terminal and run :checkhealth in Neovim to verify the installation."
print_status "Note: Mason packages (codelldb, debugpy, etc.) will be installed automatically when you first open Neovim." 