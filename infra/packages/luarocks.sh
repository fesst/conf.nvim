#!/bin/bash
set -e

# LuaRocks packages
LUAROCKS_PACKAGES=(
    "luacheck"      # Required for Lua linting
)

# Export variables
export LUAROCKS_PACKAGES
