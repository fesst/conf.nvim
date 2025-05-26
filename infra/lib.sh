#!/bin/bash

# Colors for output (CI-aware)
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

# Generic package check function
check_package() {
    local type=$1
    local package=$2

    case $type in
        brew)
            brew list "$package" &>/dev/null
            ;;
        brew_cask)
            brew list --cask "$package" &>/dev/null
            ;;
        npm)
            npm list -g "$package" &>/dev/null
            ;;
        pip)
            python3 -m pip show "$package" &>/dev/null
            ;;
        luarocks)
            luarocks list | grep -q "^$package "
            ;;
        cargo)
            cargo install --list | grep -q "^$package "
            ;;
        *)
            print_error "Unknown package type: $type"
            return 1
            ;;
    esac
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

    if check_package brew_cask "mactex-no-gui"; then
        return 0
    fi

    if check_package brew_cask "mactex"; then
        return 0
    fi

    return 1
}

# Generic package management functions
manage_packages() {
    local action=$1  # install or uninstall
    local type=$2    # package type
    shift 2
    local packages=("$@")

    local install_cmd
    local uninstall_cmd
    local check_func="check_package $type"

    case $type in
        brew)
            install_cmd="brew install"
            uninstall_cmd="brew uninstall"
            ;;
        brew_cask)
            install_cmd="brew install --cask"
            uninstall_cmd="brew uninstall --cask"
            ;;
        npm)
            install_cmd="npm install -g --loglevel=verbose ${NPM_CONFIG[@]}"
            uninstall_cmd="npm uninstall -g --loglevel=verbose"
            ;;
        pip)
            if [ "$CI" = "true" ]; then
                # In CI, ensure we're using the virtual environment's pip
                if [ -z "$VIRTUAL_ENV" ]; then
                    print_error "Virtual environment not activated in CI"
                    exit 1
                fi
                install_cmd="$VIRTUAL_ENV/bin/pip install --quiet"
                uninstall_cmd="$VIRTUAL_ENV/bin/pip uninstall -y"
            else
                install_cmd="python3 -m pip install --quiet"
                uninstall_cmd="python3 -m pip uninstall -y"
            fi
            ;;
        luarocks)
            install_cmd="luarocks install"
            uninstall_cmd="luarocks remove"
            ;;
        cargo)
            install_cmd="cargo install"
            uninstall_cmd="cargo uninstall"
            ;;
        *)
            print_error "Unknown package type: $type"
            return 1
            ;;
    esac

    if [ "$action" = "install" ]; then
        if [ "$CI" = "true" ]; then
            $install_cmd "${packages[@]}"
        else
            for package in "${packages[@]}"; do
                if ! $check_func "$package"; then
                    print_status "Installing $package..."
                    $install_cmd "$package"
                else
                    print_warning "$package is already installed"
                fi
            done
        fi
    elif [ "$action" = "uninstall" ]; then
        for package in "${packages[@]}"; do
            if $check_func "$package"; then
                print_status "Uninstalling $package..."
                $uninstall_cmd "$package"
            else
                print_warning "$package is not installed"
            fi
        done
    else
        print_error "Unknown action: $action"
        return 1
    fi
}

# Convenience functions for backward compatibility
install_brew_packages() { manage_packages install brew "$@"; }
install_brew_casks() { manage_packages install brew_cask "$@"; }
install_npm_packages() { manage_packages install npm "$@"; }
install_cargo_packages() { manage_packages install cargo "$@"; }
install_pip_packages() { manage_packages install pip "$@"; }
install_luarocks_packages() { manage_packages install luarocks "$@"; }

uninstall_brew_packages() { manage_packages uninstall brew "$@"; }
uninstall_brew_casks() { manage_packages uninstall brew_cask "$@"; }
uninstall_npm_packages() { manage_packages uninstall npm "$@"; }
uninstall_cargo_packages() { manage_packages uninstall cargo "$@"; }
uninstall_pip_packages() { manage_packages uninstall pip "$@"; }
uninstall_luarocks_packages() { manage_packages uninstall luarocks "$@"; }

# Export all functions
export -f print_status
export -f print_warning
export -f print_error
export -f check_macos
export -f check_homebrew
export -f check_package
export -f check_command
export -f ensure_cargo_path
export -f run_final_checks
export -f check_mactex
export -f manage_packages
export -f install_brew_packages
export -f install_brew_casks
export -f install_npm_packages
export -f install_cargo_packages
export -f install_pip_packages
export -f install_luarocks_packages
export -f uninstall_brew_packages
export -f uninstall_brew_casks
export -f uninstall_npm_packages
export -f uninstall_cargo_packages
export -f uninstall_pip_packages
export -f uninstall_luarocks_packages
