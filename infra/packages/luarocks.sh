#!/bin/bash
set -euo pipefail

LUAROCKS_PACKAGES=(
    "luacheck"
)

export LUAROCKS_PACKAGES

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    if ! command -v luarocks &>/dev/null; then
        echo "luarocks is required to run $0" >&2
        exit 1
    fi

    for package in "${LUAROCKS_PACKAGES[@]}"; do
        if luarocks list --porcelain 2>/dev/null | grep -q "^$package "; then
            echo "luarocks package already installed: $package"
            continue
        fi
        luarocks install "$package"
    done
fi
