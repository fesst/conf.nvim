#!/bin/bash
set -euo pipefail

NPM_PACKAGES=(
    "typescript@latest"
    "typescript-language-server@latest"
    "prettier@latest"
    "eslint@latest"
    "@angular/cli@latest"
    "eslint_d@latest"
)

NPM_CONFIG=(
    "--no-audit"
    "--no-fund"
    "--no-package-lock"
    "--no-save"
    "--prefer-offline"
    "--progress=false"
)

export NPM_PACKAGES
export NPM_CONFIG

normalize_npm_package() {
    local package=$1
    if [[ $package == *@* ]]; then
        printf '%s\n' "${package%@*}"
    else
        printf '%s\n' "$package"
    fi
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    if ! command -v npm &>/dev/null; then
        echo "npm is required to run $0" >&2
        exit 1
    fi

    for package in "${NPM_PACKAGES[@]}"; do
        normalized_package="$(normalize_npm_package "$package")"
        if npm list -g --depth=0 "$normalized_package" &>/dev/null; then
            echo "npm package already installed: $normalized_package"
            continue
        fi
        npm install -g "$package" "${NPM_CONFIG[@]}"
    done
fi
