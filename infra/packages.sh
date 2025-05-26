#!/bin/bash
set -e

# Source individual package files
source "$(dirname "$0")/packages/brew.sh"
source "$(dirname "$0")/packages/npm.sh"
source "$(dirname "$0")/packages/pip.sh"
source "$(dirname "$0")/packages/luarocks.sh"
source "$(dirname "$0")/packages/cargo.sh"
source "$(dirname "$0")/packages/nvim.sh"
