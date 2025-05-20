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

# Uninstall Homebrew packages
print_status "Uninstalling Homebrew packages..."
for package in "${BREW_PACKAGES[@]}"; do
    if check_brew_package "$package"; then
        print_status "Uninstalling $package..."
        brew uninstall "$package"
    else
        print_warning "$package is not installed"
    fi
done

# Uninstall Homebrew casks
print_status "Uninstalling Homebrew casks..."
for cask in "${BREW_CASKS[@]}"; do
    if check_brew_cask "$cask"; then
        print_status "Uninstalling $cask..."
        brew uninstall --cask "$cask"
    else
        print_warning "$cask is not installed"
    fi
done

# Uninstall Node.js and npm packages
print_status "Uninstalling Node.js and npm packages..."
for package in "${NPM_PACKAGES[@]}"; do
    if check_npm_package "$package"; then
        print_status "Uninstalling $package..."
        npm uninstall -g "$package"
    else
        print_warning "$package is not installed"
    fi
done

# Uninstall Node.js if no other npm packages are installed
if ! npm list -g &>/dev/null; then
    print_status "Uninstalling Node.js..."
    brew uninstall node
fi

# Uninstall Rust and Cargo packages
print_status "Uninstalling Rust and Cargo packages..."
if check_command rustup; then
    print_status "Uninstalling Rust..."
    rustup self uninstall -y
fi

# Uninstall rust-analyzer
if check_brew_package rust-analyzer; then
    print_status "Uninstalling rust-analyzer..."
    brew uninstall rust-analyzer
fi

# Uninstall Python packages
print_status "Uninstalling Python packages..."
for package in "${PIP_PACKAGES[@]}"; do
    if check_pip_package "$package"; then
        print_status "Uninstalling $package..."
        python3 -m pip uninstall -y "$package"
    else
        print_warning "$package is not installed"
    fi
done

# Uninstall Python if no other pip packages are installed
if ! python3 -m pip list &>/dev/null; then
    print_status "Uninstalling Python..."
    brew uninstall python
fi

# Uninstall LuaRocks packages
print_status "Uninstalling LuaRocks packages..."
for package in "${LUAROCKS_PACKAGES[@]}"; do
    if check_luarocks_package "$package"; then
        print_status "Uninstalling $package..."
        luarocks remove "$package"
    else
        print_warning "$package is not installed"
    fi
done

# Uninstall Cargo packages
print_status "Uninstalling Cargo packages..."
for package in "${CARGO_PACKAGES[@]}"; do
    if check_cargo_package "$package"; then
        print_status "Uninstalling $package..."
        cargo uninstall "$package"
    else
        print_warning "$package is not installed"
    fi
done

# Uninstall CodeLLDB
if [ -f "$(dirname "$0")/codelldb.sh" ]; then
    print_status "Uninstalling CodeLLDB..."
    "$(dirname "$0")/codelldb.sh" --uninstall
fi

# Clean up Neovim Mason packages
print_status "Cleaning up Neovim Mason packages..."
if check_command nvim; then
    nvim --headless -c "MasonUninstallAll" -c "qa"
fi

# Final message
print_status "Cleanup completed successfully!"
print_status "Note: Some configuration files may still exist in your home directory."
print_status "You may want to manually remove:"
for dir in "${NVIM_DIRS[@]}"; do
    print_status "  - $dir"
done 