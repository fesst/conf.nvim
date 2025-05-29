#!/bin/bash
set -e

# Cargo packages
CARGO_PACKAGES=(
    "stylua"        # Required for Lua formatting
)

# Export variables
export CARGO_PACKAGES

# Check if we should install stylua
if [ "${INSTALL_STYLUA:-true}" = "true" ]; then
    # Install each package
    for package in "${CARGO_PACKAGES[@]}"; do
        echo "Installing $package..."
        cargo install "$package" || {
            echo "Failed to install $package. Retrying..."
            cargo install "$package" --force
        }
    done

    # Verify installations
    for package in "${CARGO_PACKAGES[@]}"; do
        if ! command -v "$package" &> /dev/null; then
            echo "Error: $package installation failed or not found in PATH"
            echo "Current PATH: $PATH"
            exit 1
        fi
        echo "$package installed successfully at $(which "$package")"
    done
else
    echo "Skipping stylua installation as INSTALL_STYLUA is set to false"
fi
