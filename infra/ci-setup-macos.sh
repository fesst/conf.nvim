#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

CI=true INSTALL_BREW_CASKS=false "$SCRIPT_DIR/install.sh"
