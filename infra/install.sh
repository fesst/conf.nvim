#!/bin/bash

set -e

# Source utility functions and package collections
source "$(dirname "$0")/lib.sh"
source "$(dirname "$0")/packages.sh"

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

# Check system requirements
check_macos
check_homebrew

# Install Homebrew packages
print_status "Installing Homebrew packages..."
for package in "${BREW_PACKAGES[@]}"; do
    if ! check_brew_package "$package"; then
        print_status "Installing $package..."
        brew install "$package"
    else
        print_warning "$package is already installed"
    fi
done

# Install Homebrew casks
print_status "Installing Homebrew casks..."
for cask in "${BREW_CASKS[@]}"; do
    if ! check_brew_cask "$cask"; then
        print_status "Installing $cask..."
        brew install --cask "$cask"
    else
        print_warning "$cask is already installed"
    fi
done

# Install Node.js and npm packages
print_status "Installing Node.js and npm packages..."
if ! check_command node; then
    print_status "Installing Node.js..."
    brew install node
fi

for package in "${NPM_PACKAGES[@]}"; do
    if ! check_npm_package "$package"; then
        print_status "Installing $package..."
        npm install -g "$package"
    else
        print_warning "$package is already installed"
    fi
done

# Install Rust and Cargo packages
print_status "Installing Rust and Cargo packages..."
if ! check_command rustc; then
    print_status "Installing Rust..."
    brew install rust
fi

# Ensure cargo is in PATH
ensure_cargo_path

# Install rust-analyzer through Homebrew
if ! check_brew_package rust-analyzer; then
    print_status "Installing rust-analyzer..."
    brew install rust-analyzer
else
    print_warning "rust-analyzer is already installed"
fi

# Install Python packages
print_status "Installing Python packages..."
if ! check_command python3; then
    print_status "Installing Python..."
    brew install python
fi

for package in "${PIP_PACKAGES[@]}"; do
    if ! check_pip_package "$package"; then
        print_status "Installing $package..."
        python3 -m pip install --quiet "$package"
    else
        print_warning "$package is already installed"
    fi
done

# Install LuaRocks packages
print_status "Installing LuaRocks packages..."
for package in "${LUAROCKS_PACKAGES[@]}"; do
    if ! check_luarocks_package "$package"; then
        print_status "Installing $package..."
        luarocks install "$package"
    else
        print_warning "$package is already installed"
    fi
done

# Install Cargo packages
print_status "Installing Cargo packages..."
for package in "${CARGO_PACKAGES[@]}"; do
    if ! check_cargo_package "$package"; then
        print_status "Installing $package..."
        cargo install "$package"
    else
        print_warning "$package is already installed"
    fi
done

# Install CodeLLDB
"$(dirname "$0")/codelldb.sh"

# Run final checks
run_final_checks

print_status "Installation completed successfully!"
print_status "Please restart your terminal and run :checkhealth in Neovim to verify the installation."
print_status "Note: Mason packages (codelldb, debugpy, etc.) will be installed automatically when you first open Neovim." 