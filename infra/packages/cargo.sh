#!/bin/bash
set -e

# Cargo packages
CARGO_PACKAGES=(
    "stylua"        # Required for Lua formatting
)

# Export variables
export CARGO_PACKAGES

# Function to check if a package is installed
check_cargo_package() {
    local package=$1
    cargo install --list | grep -q "^$package "
    return $?
}

# Install packages
for package in "${CARGO_PACKAGES[@]}"; do
    if ! check_cargo_package "$package"; then
        echo "Installing $package..."
        cargo install "$package" --verbose
    else
        echo "$package is already installed"
    fi
done
