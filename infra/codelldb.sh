#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib.sh"

CODELDB_VERSION="${CODELDB_VERSION:-1.11.0}"
CODELDB_DIR="$HOME/.local/share/nvim/mason/packages/codelldb"

detect_archive_name() {
    local os arch
    os="$(uname -s)"
    arch="$(uname -m)"

    case "$os:$arch" in
    Darwin:arm64)
        printf 'codelldb-aarch64-darwin.vsix\n'
        ;;
    Darwin:x86_64)
        printf 'codelldb-x86_64-darwin.vsix\n'
        ;;
    Linux:x86_64)
        printf 'codelldb-x86_64-linux.vsix\n'
        ;;
    Linux:aarch64)
        printf 'codelldb-aarch64-linux.vsix\n'
        ;;
    *)
        print_error "Unsupported platform for CodeLLDB: $os / $arch"
        exit 1
        ;;
    esac
}

if [ "${1:-}" = "--uninstall" ]; then
    rm -rf "$CODELDB_DIR"
    print_status "Removed CodeLLDB from $CODELDB_DIR"
    exit 0
fi

CODELDB_ARCHIVE="$(detect_archive_name)"

if [ -f "$CODELDB_DIR/extension/adapter/codelldb" ]; then
    print_warning "CodeLLDB is already installed"
    exit 0
fi

if ! command -v unzip &>/dev/null; then
    print_error "unzip is required to install CodeLLDB"
    exit 1
fi

print_status "Installing CodeLLDB $CODELDB_VERSION ($CODELDB_ARCHIVE)"
TEMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TEMP_DIR"' EXIT

curl -fsSL "https://github.com/vadimcn/codelldb/releases/download/v$CODELDB_VERSION/$CODELDB_ARCHIVE" \
    -o "$TEMP_DIR/codelldb.vsix"
mkdir -p "$CODELDB_DIR"
unzip -q "$TEMP_DIR/codelldb.vsix" -d "$CODELDB_DIR"
print_status "CodeLLDB installed successfully"
