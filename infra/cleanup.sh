#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/lib.sh"
source "$SCRIPT_DIR/packages.sh"

# Check system requirements
check_macos
check_homebrew

# Uninstall Homebrew packages
print_status "Uninstalling Homebrew packages..."
uninstall_brew_packages "${BREW_PACKAGES[@]}"

# Uninstall Homebrew casks
print_status "Uninstalling Homebrew casks..."
uninstall_brew_casks "${BREW_CASKS[@]}"

# Uninstall Node.js and npm packages
print_status "Uninstalling Node.js and npm packages..."
uninstall_npm_packages "${NPM_PACKAGES[@]}"

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
if check_package brew rust-analyzer; then
    print_status "Uninstalling rust-analyzer..."
    brew uninstall rust-analyzer
fi

# Uninstall Python packages
print_status "Uninstalling Python packages..."
uninstall_pip_packages "${PIP_PACKAGES[@]}"

# Uninstall Python if no other pip packages are installed
if ! python3 -m pip list &>/dev/null; then
    print_status "Uninstalling Python..."
    brew uninstall python
fi

# Uninstall LuaRocks packages
print_status "Uninstalling LuaRocks packages..."
uninstall_luarocks_packages "${LUAROCKS_PACKAGES[@]}"

# Uninstall Cargo packages
print_status "Uninstalling Cargo packages..."
uninstall_cargo_packages "${CARGO_PACKAGES[@]}"

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

# Remove Lua tools
if command -v stylua &>/dev/null; then
    echo "Removing stylua..."
    cargo uninstall stylua
fi

# Final message
print_status "Cleanup completed successfully!"
print_status "Note: Some configuration files may still exist in your home directory."
print_status "You may want to manually remove:"
for dir in "${NVIM_DIRS[@]}"; do
    print_status "  - $dir"
done
