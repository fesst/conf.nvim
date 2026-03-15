#!/bin/bash

set -euo pipefail

# Install required tools if not present
if ! command -v stylua &>/dev/null; then
    echo "Installing stylua..."
    cargo install stylua
fi

if ! command -v luacheck &>/dev/null; then
    echo "Installing luacheck..."
    luarocks install luacheck
fi

echo "Formatting Lua files..."
stylua lua/ after/plugin/

echo "Cleaning up whitespace..."
find lua/ after/plugin/ -type f -name "*.lua" -exec perl -0pi -e 's/[ \t]+$//mg; s/\n{3,}/\n\n/g' {} +

# Run luacheck
echo "Running luacheck..."
luacheck lua/ after/plugin/ --codes --ranges --formatter plain

echo "Formatting complete!"
