#!/bin/bash

set -e

# Source utility functions and package collections
source "$(dirname "$0")/lib.sh"
source "$(dirname "$0")/packages.sh"

# Colors for output (only if not in CI)
if [ "$CI" != "true" ]; then
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    NC='\033[0m' # No Color
else
    RED=''
    GREEN=''
    YELLOW=''
    NC=''
fi

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

# Check system requirements (skip in CI)
if [ "$CI" != "true" ]; then
    check_macos
    check_homebrew
fi

# Install Homebrew packages
print_status "Installing Homebrew packages..."
if [ "$CI" = "true" ]; then
    # In CI, install all packages at once
    brew install "${BREW_PACKAGES[@]}"
else
    # In local environment, check and install individually
    for package in "${BREW_PACKAGES[@]}"; do
        if ! check_brew_package "$package"; then
            print_status "Installing $package..."
            brew install "$package"
        else
            print_warning "$package is already installed"
        fi
    done
fi

# Install MacTeX (skip in CI)
if [ "$CI" != "true" ]; then
    if ! check_mactex; then
        print_status "Installing MacTeX..."
        brew install --cask mactex
    else
        print_warning "MacTeX is already installed"
    fi
fi

# Install other Homebrew casks
print_status "Installing Homebrew casks..."
if [ "$CI" = "true" ]; then
    # In CI, install all casks at once (except mactex)
    CASKS=("${BREW_CASKS[@]/mactex/}")
    brew install --cask "${CASKS[@]}"
else
    for cask in "${BREW_CASKS[@]}"; do
        if [ "$cask" != "mactex" ]; then
            if ! check_brew_cask "$cask"; then
                print_status "Installing $cask..."
                brew install --cask "$cask"
            else
                print_warning "$cask is already installed"
            fi
        fi
    done
fi

# Install Node.js and npm packages
print_status "Installing Node.js and npm packages..."
if [ "$CI" = "true" ]; then
    brew install node
    npm install -g "${NPM_PACKAGES[@]}"
else
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
fi

# Install Rust and Cargo packages
print_status "Installing Rust and Cargo packages..."
if [ "$CI" = "true" ]; then
    brew install rust rust-analyzer
    cargo install "${CARGO_PACKAGES[@]}"
else
    if ! check_command rustc; then
        print_status "Installing Rust..."
        brew install rust
    fi

    ensure_cargo_path

    if ! check_brew_package rust-analyzer; then
        print_status "Installing rust-analyzer..."
        brew install rust-analyzer
    else
        print_warning "rust-analyzer is already installed"
    fi

    for package in "${CARGO_PACKAGES[@]}"; do
        if ! check_cargo_package "$package"; then
            print_status "Installing $package..."
            cargo install "$package"
        else
            print_warning "$package is already installed"
        fi
    done
fi

# Install Python packages
print_status "Installing Python packages..."
if [ "$CI" = "true" ]; then
    # In CI, we assume the virtual environment is already activated
    python3 -m pip install --quiet "${PIP_PACKAGES[@]}"
else
    if ! check_command python3; then
        print_status "Installing Python..."
        brew install python
    fi

    # Check if we're in a virtual environment
    if [ -z "$VIRTUAL_ENV" ]; then
        print_warning "No virtual environment detected. Creating one..."
        if [ ! -d ".venv" ]; then
            print_status "Creating Python virtual environment..."
            python3 -m venv .venv
        fi
        source .venv/bin/activate
    else
        print_status "Using existing virtual environment: $VIRTUAL_ENV"
    fi

    for package in "${PIP_PACKAGES[@]}"; do
        if ! check_pip_package "$package"; then
            print_status "Installing $package..."
            python3 -m pip install --quiet "$package"
        else
            print_warning "$package is already installed"
        fi
    done
fi

# Install LuaRocks packages
print_status "Installing LuaRocks packages..."
if [ "$CI" = "true" ]; then
    luarocks install "${LUAROCKS_PACKAGES[@]}"
else
    for package in "${LUAROCKS_PACKAGES[@]}"; do
        if ! check_luarocks_package "$package"; then
            print_status "Installing $package..."
            luarocks install "$package"
        else
            print_warning "$package is already installed"
        fi
    done
fi

# Install CodeLLDB
"$(dirname "$0")/codelldb.sh"

# Run final checks (skip in CI)
if [ "$CI" != "true" ]; then
    run_final_checks
    print_status "Installation completed successfully!"
    print_status "Please restart your terminal and run :checkhealth in Neovim to verify the installation."
    print_status "Note: Mason packages (codelldb, debugpy, etc.) will be installed automatically when you first open Neovim."
fi 