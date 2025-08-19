#!/bin/bash
set -e

# Install system packages
chmod +x infra/packages/brew.sh
./infra/packages/brew.sh || {
    echo "Failed to install system packages. Retrying..."
    brew update
    ./infra/packages/brew.sh
}

# Install Node.js packages
chmod +x infra/packages/npm.sh
./infra/packages/npm.sh || {
    echo "Failed to install Node.js packages. Retrying..."
    npm cache clean --force
    ./infra/packages/npm.sh
}

# Install Rust if not already installed
if ! command -v rustc &>/dev/null; then
    echo "Installing Rust..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
fi

# Ensure Cargo bin is in PATH
export PATH="$HOME/.cargo/bin:$PATH"

# Install Rust packages
chmod +x infra/packages/cargo.sh
./infra/packages/cargo.sh || {
    echo "Failed to install Rust packages. Retrying..."
    cargo clean
    ./infra/packages/cargo.sh
}

# Install Python packages
chmod +x infra/packages/pip.sh
source "$RUNNER_TOOL_CACHE/venv/bin/activate"
./infra/packages/pip.sh || {
    echo "Failed to install Python packages. Retrying..."
    pip cache purge
    ./infra/packages/pip.sh
}

# Install Lua packages
chmod +x infra/packages/luarocks.sh
./infra/packages/luarocks.sh || {
    echo "Failed to install Lua packages. Retrying..."
    luarocks config --local lua_version 5.4
    ./infra/packages/luarocks.sh
}

# Install Neovim configuration
chmod +x infra/packages/nvim.sh
./infra/packages/nvim.sh || {
    echo "Failed to install Neovim configuration. Retrying..."
    rm -rf ~/.local/share/nvim
    ./infra/packages/nvim.sh
}
