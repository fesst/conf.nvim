#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/packages/brew.sh"
source "$SCRIPT_DIR/packages/npm.sh"
source "$SCRIPT_DIR/packages/pip.sh"
source "$SCRIPT_DIR/packages/luarocks.sh"
source "$SCRIPT_DIR/packages/cargo.sh"
source "$SCRIPT_DIR/packages/nvim.sh"
