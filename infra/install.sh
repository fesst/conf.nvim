#!/bin/bash

set -e

# Source utility functions and package collections
source "$(dirname "$0")/lib.sh"
source "$(dirname "$0")/packages.sh"

# Check system requirements (skip in CI)
if [ "$CI" != "true" ]; then
    check_macos
    check_homebrew
fi

# Install Homebrew packages
print_status "Installing Homebrew packages..."
install_brew_packages "${BREW_PACKAGES[@]}"

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
install_brew_casks "${BREW_CASKS[@]}"

# Install Node.js and npm packages
print_status "Installing Node.js and npm packages..."
if [ "$CI" = "true" ]; then
    brew install node
else
    if ! check_command node; then
        print_status "Installing Node.js..."
        brew install node
    fi
fi
install_npm_packages "${NPM_PACKAGES[@]}"

# Install Rust and Cargo packages
print_status "Installing Rust and Cargo packages..."
if [ "$CI" = "true" ]; then
    brew install rust rust-analyzer
else
    if ! check_command rustc; then
        print_status "Installing Rust..."
        brew install rust
    fi

    ensure_cargo_path

    if ! check_package brew rust-analyzer; then
        print_status "Installing rust-analyzer..."
        brew install rust-analyzer
    else
        print_warning "rust-analyzer is already installed"
    fi
fi
install_cargo_packages "${CARGO_PACKAGES[@]}"

# Install Python packages
print_status "Installing Python packages..."
if [ "$CI" = "true" ]; then
    # In CI, ensure we're in the virtual environment
    if [ -z "$VIRTUAL_ENV" ]; then
        print_error "Virtual environment not activated in CI"
        exit 1
    fi
    # Ensure pip is using the virtual environment
    export PIP_PREFIX="$VIRTUAL_ENV"
    install_pip_packages "${PIP_PACKAGES[@]}"
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

    install_pip_packages "${PIP_PACKAGES[@]}"
fi

# Install LuaRocks packages
print_status "Installing LuaRocks packages..."
install_luarocks_packages "${LUAROCKS_PACKAGES[@]}"

# Install CodeLLDB
"$(dirname "$0")/codelldb.sh"

# Install Lua tools
if ! command -v stylua &> /dev/null; then
    echo "Installing stylua..."
    cargo install stylua
fi

# Run final checks (skip in CI)
if [ "$CI" != "true" ]; then
    run_final_checks
    print_status "Installation completed successfully!"
    print_status "Please restart your terminal and run :checkhealth in Neovim to verify the installation."
    print_status "Note: Mason packages (codelldb, debugpy, etc.) will be installed automatically when you first open Neovim."
fi
