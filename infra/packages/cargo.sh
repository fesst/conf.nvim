#!/bin/bash
set -e

# Cargo packages
CARGO_PACKAGES=(
    "stylua"        # Required for Lua formatting
)

# Export variables
export CARGO_PACKAGES

# Ensure cargo is in PATH
if [ -f "$HOME/.cargo/env" ]; then
    source "$HOME/.cargo/env"
fi

# Add cargo bin to PATH if not already present
if [[ ":$PATH:" != *":$HOME/.cargo/bin:"* ]]; then
    export PATH="$HOME/.cargo/bin:$PATH"
fi

# Check if we should install stylua
if [ "${INSTALL_STYLUA:-true}" = "true" ]; then
    # Install each package
    for package in "${CARGO_PACKAGES[@]}"; do
        echo "Installing $package..."
        if ! cargo install "$package"; then
            echo "Failed to install $package. Retrying with --force..."
            if ! cargo install "$package" --force; then
                echo "Error: Failed to install $package even with --force"
                echo "Current PATH: $PATH"
                echo "Cargo bin location: $HOME/.cargo/bin"
                exit 1
            fi
        fi
    done

    # Verify installations
    for package in "${CARGO_PACKAGES[@]}"; do
        if ! command -v "$package" &> /dev/null; then
            echo "Error: $package installation failed or not found in PATH"
            echo "Current PATH: $PATH"
            echo "Cargo bin location: $HOME/.cargo/bin"
            echo "Listing cargo bin directory:"
            ls -la "$HOME/.cargo/bin"
            exit 1
        fi
        echo "$package installed successfully at $(which "$package")"
    done
else
    echo "Skipping stylua installation as INSTALL_STYLUA is set to false"
fi
