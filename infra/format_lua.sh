#!/bin/bash

# Format all Lua files in lua/motleyfesst and after/plugins using stylua

set -e

CONFIG_FILE=".stylua.toml"

if ! command -v stylua &> /dev/null; then
  echo "stylua is not installed. Please install it first (e.g., cargo install stylua)."
  exit 1
fi

if [ ! -f "$CONFIG_FILE" ]; then
  echo ".stylua.toml config file not found in the project root."
  exit 1
fi

# Format lua/motleyfesst
stylua --config-path "$CONFIG_FILE" lua/motleyfesst/*.lua

# Format after/plugins
stylua --config-path "$CONFIG_FILE" after/plugins/*.lua

stylua --config-path "$CONFIG_FILE" init.lua

echo "All Lua files formatted successfully." 