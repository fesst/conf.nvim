#!/bin/bash
set -e

# Python packages
PIP_PACKAGES=(
    "pynvim"        # Required for Python integration
    "black"         # Required for Python formatting
    "flake8"        # Required for Python linting
    "isort"         # Required for Python import sorting
)

# Install packages
echo "Installing Python packages..."
for package in "${PIP_PACKAGES[@]}"; do
    echo "Installing $package..."
    pip install "$package"
done

# Verify installations
echo "Verifying installations..."
pip list
