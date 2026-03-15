#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/lib.sh"
source "$SCRIPT_DIR/packages.sh"

ensure_runtime() {
    local command_name=$1
    local brew_package=$2

    if check_command "$command_name"; then
        return 0
    fi

    print_status "Installing missing runtime: $brew_package"
    brew install "$brew_package"
}

ensure_python_venv() {
    if [ -n "${VIRTUAL_ENV:-}" ]; then
        print_status "Using active virtual environment: $VIRTUAL_ENV"
        return 0
    fi

    local venv_dir="${SCRIPT_DIR%/infra}/.venv"
    if [ ! -d "$venv_dir" ]; then
        print_status "Creating Python virtual environment at $venv_dir"
        python3 -m venv "$venv_dir"
    fi

    # shellcheck disable=SC1090
    source "$venv_dir/bin/activate"
}

if [ "$CI" != "true" ]; then
    check_macos
    check_homebrew
fi

ensure_runtime python3 python
ensure_runtime node node
ensure_runtime cargo rust

print_status "Installing Homebrew packages..."
"$SCRIPT_DIR/packages/brew.sh"

if [ "${INSTALL_BREW_CASKS:-false}" = "true" ]; then
    print_status "Installing optional Homebrew casks..."
    INSTALL_BREW_CASKS=true "$SCRIPT_DIR/packages/brew.sh"
fi

print_status "Installing Node.js packages..."
"$SCRIPT_DIR/packages/npm.sh"

ensure_python_venv
print_status "Installing Python packages..."
"$SCRIPT_DIR/packages/pip.sh"

print_status "Installing Cargo packages..."
"$SCRIPT_DIR/packages/cargo.sh"

if [ "${INSTALL_LUAROCKS_PACKAGES:-true}" = "true" ]; then
    print_status "Installing LuaRocks packages..."
    "$SCRIPT_DIR/packages/luarocks.sh"
fi

print_status "Syncing Neovim plugins..."
"$SCRIPT_DIR/packages/nvim.sh"

if [ "$CI" != "true" ]; then
    run_final_checks
    print_status "Installation completed successfully"
fi
