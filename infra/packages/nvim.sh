#!/bin/bash
set -euo pipefail

NVIM_DIRS=(
    "$HOME/.config/nvim"
    "$HOME/.local/share/nvim"
    "$HOME/.cache/nvim"
)

export NVIM_DIRS

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    if ! command -v nvim &>/dev/null; then
        echo "nvim is required to run $0" >&2
        exit 1
    fi

    if [ "${SYNC_NVIM_PLUGINS:-true}" = "true" ]; then
        nvim --headless "+Lazy! restore" "+qa"
    fi
fi
