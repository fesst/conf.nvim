#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print status messages
print_status() {
    echo -e "${GREEN}[+]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

print_error() {
    echo -e "${RED}[x]${NC} $1"
}

# Install CodeLLDB
print_status "Installing CodeLLDB..."
CODELDB_VERSION="1.9.2"
CODELDB_DIR="$HOME/.local/share/nvim/mason/packages/codelldb"
CODELDB_ARCHIVE="codelldb-aarch64-darwin.vsix"

if [ ! -f "$CODELDB_DIR/extension/adapter/codelldb" ]; then
    print_status "Downloading CodeLLDB..."
    # Create temp directory
    TEMP_DIR=$(mktemp -d)
    cd "$TEMP_DIR"
    
    # Download CodeLLDB
    curl -L "https://github.com/vadimcn/codelldb/releases/download/v$CODELDB_VERSION/$CODELDB_ARCHIVE" -o codelldb.vsix
    
    # Create directory if it doesn't exist
    mkdir -p "$CODELDB_DIR"
    
    # Unzip the vsix file (it's just a zip file)
    unzip -q codelldb.vsix -d "$CODELDB_DIR"
    
    # Clean up
    cd - > /dev/null
    rm -rf "$TEMP_DIR"
    
    print_status "CodeLLDB installed successfully"
else
    print_warning "CodeLLDB is already installed"
fi 