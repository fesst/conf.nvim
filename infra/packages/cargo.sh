#!/bin/bash
set -e

# Cargo packages
CARGO_PACKAGES=(
    "stylua"        # Required for Lua formatting
)

# Export variables
export CARGO_PACKAGES
