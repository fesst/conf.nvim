#!/bin/bash

# Exit on error
set -e

# Install required tools if not present
if ! command -v stylua &> /dev/null; then
    echo "Installing stylua..."
    cargo install stylua
fi

if ! command -v luacheck &> /dev/null; then
    echo "Installing luacheck..."
    luarocks install luacheck
fi

# Format Lua files
echo "Formatting Lua files..."
stylua lua/ after/plugin/

# Remove trailing whitespace and empty lines
echo "Cleaning up whitespace..."
find lua/ after/plugin/ -type f -name "*.lua" -exec sed -i 's/[[:space:]]*$//' {} +
find lua/ after/plugin/ -type f -name "*.lua" -exec sed -i '/^[[:space:]]*$/d' {} +

# Run luacheck
echo "Running luacheck..."
luacheck lua/ after/plugin/ --codes --ranges --formatter plain

echo "Formatting complete!" 