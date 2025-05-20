#!/bin/bash

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

# Function to check if running on macOS
check_macos() {
    if [[ "$OSTYPE" != "darwin"* ]]; then
        print_error "This script is currently only supported on macOS"
        exit 1
    fi
}

# Function to check if Homebrew is installed
check_homebrew() {
    if ! command -v brew &> /dev/null; then
        print_error "Homebrew is not installed. Please install it first from https://brew.sh"
        exit 1
    fi
}

# Function to check if a package is installed via Homebrew
check_brew_package() {
    local package=$1
    brew list "$package" &>/dev/null
}

# Function to check if a cask is installed via Homebrew
check_brew_cask() {
    local cask=$1
    brew list --cask "$cask" &>/dev/null
}

# Function to check if an npm package is installed globally
check_npm_package() {
    local package=$1
    npm list -g "$package" &>/dev/null
}

# Function to check if a pip package is installed
check_pip_package() {
    local package=$1
    python3 -m pip show "$package" &>/dev/null
}

# Function to check if a LuaRocks package is installed
check_luarocks_package() {
    local package=$1
    luarocks list | grep -q "^$package "
}

# Function to check if a Cargo package is installed
check_cargo_package() {
    local package=$1
    cargo install --list | grep -q "^$package "
}

# Function to check if a command exists
check_command() {
    local cmd=$1
    command -v "$cmd" &>/dev/null
}

# Function to ensure cargo is in PATH
ensure_cargo_path() {
    if check_command rustup; then
        source "$HOME/.cargo/env"
    fi
}

# Function to run final checks
run_final_checks() {
    print_status "Running final checks..."
    if ! check_command nvim; then
        print_error "Neovim is not installed. Please install it first."
        exit 1
    fi
}

# Function to check MacTeX installation status
check_mactex() {
    if check_command latexmk; then
        return 0
    fi

    if check_brew_cask "mactex-no-gui"; then
        return 0
    fi

    if check_brew_cask "mactex"; then
        return 0
    fi

    return 1
}

# Export all functions
export -f print_status
export -f print_warning
export -f print_error
export -f check_macos
export -f check_homebrew
export -f check_brew_package
export -f check_brew_cask
export -f check_npm_package
export -f check_pip_package
export -f check_luarocks_package
export -f check_cargo_package
export -f check_command
export -f ensure_cargo_path
export -f run_final_checks
export -f check_mactex 