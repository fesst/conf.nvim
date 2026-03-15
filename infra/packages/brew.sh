#!/bin/bash
set -euo pipefail

BREW_PACKAGES=(
    "fd"
    "fzf"
    "git"
    "llvm"
    "luarocks"
    "neovim"
    "pkg-config"
    "ripgrep"
    "shellcheck"
    "shfmt"
    "tree-sitter"
)

BREW_CASKS=(
    "skim"
)

export BREW_PACKAGES
export BREW_CASKS

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    if ! command -v brew &>/dev/null; then
        echo "Homebrew is required to run $0" >&2
        exit 1
    fi

    for package in "${BREW_PACKAGES[@]}"; do
        if brew list "$package" &>/dev/null; then
            echo "brew package already installed: $package"
            continue
        fi
        brew install "$package"
    done

    if [ "${INSTALL_BREW_CASKS:-false}" = "true" ]; then
        for cask in "${BREW_CASKS[@]}"; do
            if brew list --cask "$cask" &>/dev/null; then
                echo "brew cask already installed: $cask"
                continue
            fi
            brew install --cask "$cask"
        done
    fi
fi
