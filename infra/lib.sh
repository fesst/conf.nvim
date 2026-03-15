#!/bin/bash

CI="${CI:-false}"
if [ "$CI" != "true" ]; then
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    NC='\033[0m'
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

check_macos() {
    if [[ $OSTYPE != "darwin"* ]]; then
        print_error "This script is currently only supported on macOS"
        exit 1
    fi
}

check_homebrew() {
    if ! command -v brew &>/dev/null; then
        print_error "Homebrew is not installed. Please install it first from https://brew.sh"
        exit 1
    fi
}

normalize_npm_package() {
    local package=$1
    if [[ $package == *@* ]]; then
        printf '%s\n' "${package%@*}"
    else
        printf '%s\n' "$package"
    fi
}

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
        npm list -g --depth=0 "$(normalize_npm_package "$package")" &>/dev/null
        ;;
    pip)
        python3 -m pip show "$package" &>/dev/null
        ;;
    luarocks)
        luarocks list --porcelain 2>/dev/null | grep -q "^$package "
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

check_command() {
    local cmd=$1
    command -v "$cmd" &>/dev/null
}

ensure_cargo_path() {
    if check_command rustup; then
        # shellcheck disable=SC1090
        source "$HOME/.cargo/env"
    fi
}

run_final_checks() {
    print_status "Running final checks..."
    if ! check_command nvim; then
        print_error "Neovim is not installed. Please install it first."
        exit 1
    fi
}

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

manage_packages() {
    local action=$1
    local type=$2
    shift 2
    local packages=("$@")

    local install_cmd
    local uninstall_cmd

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
        install_cmd="npm install -g"
        uninstall_cmd="npm uninstall -g"
        ;;
    pip)
        install_cmd="python3 -m pip install"
        uninstall_cmd="python3 -m pip uninstall -y"
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
        for package in "${packages[@]}"; do
            if check_package "$type" "$package"; then
                print_warning "$package is already installed"
                continue
            fi

            print_status "Installing $package..."
            case $type in
            npm)
                $install_cmd "$package" "${NPM_CONFIG[@]}"
                ;;
            *)
                $install_cmd "$package"
                ;;
            esac
        done
    elif [ "$action" = "uninstall" ]; then
        for package in "${packages[@]}"; do
            if check_package "$type" "$package"; then
                print_status "Uninstalling $package..."
                case $type in
                npm)
                    $uninstall_cmd "$(normalize_npm_package "$package")"
                    ;;
                *)
                    $uninstall_cmd "$package"
                    ;;
                esac
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
export -f normalize_npm_package
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
