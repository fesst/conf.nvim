#!/bin/bash
set -e

# Python packages
PIP_PACKAGES=(
    "pynvim"        # Required for Python integration
    "black"         # Required for Python formatting
    "flake8"        # Required for Python linting
    "isort"         # Required for Python import sorting
)

# Export variables
export PIP_PACKAGES
