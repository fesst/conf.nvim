#!/bin/bash
set -euo pipefail

PIP_PACKAGES=(
    "black"
    "flake8"
    "isort"
    "pynvim"
    "pytest"
)

export PIP_PACKAGES

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    if ! command -v python3 &>/dev/null; then
        echo "python3 is required to run $0" >&2
        exit 1
    fi

    python3 -m pip install --upgrade pip
    python3 -m pip install "${PIP_PACKAGES[@]}"
fi
