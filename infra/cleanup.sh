#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Starting cleanup process...${NC}"

# Check Homebrew packages
echo -e "\n${YELLOW}Checking Homebrew packages...${NC}"
brew_packages=(
    "fzf"
    "ripgrep"
    "fd"
    "llvm@19"
    "cmake"
    "delve"
    "git"
    "gcc"
    "make"
    "pkg-config"
    "php"
    "composer"
    "luarocks"
)

for package in "${brew_packages[@]}"; do
    if brew list "$package" &>/dev/null; then
        echo -e "${GREEN}✓ $package${NC}"
    else
        echo -e "${RED}✗ $package not found${NC}"
    fi
done

# Remove other LLVM versions if they exist
if brew list llvm &>/dev/null; then
    echo -e "\n${YELLOW}Removing generic llvm package...${NC}"
    brew uninstall llvm
fi

# Check Node.js packages
echo -e "\n${YELLOW}Checking Node.js packages...${NC}"
npm_packages=(
    "typescript"
    "typescript-language-server"
    "prettier"
    "eslint"
    "@angular/cli"
)

for package in "${npm_packages[@]}"; do
    if npm list -g "$package" &>/dev/null; then
        echo -e "${GREEN}✓ $package${NC}"
    else
        echo -e "${RED}✗ $package not found${NC}"
    fi
done

# Check Python packages
echo -e "\n${YELLOW}Checking Python packages...${NC}"
pip_packages=(
    "pynvim"
    "black"
    "flake8"
)

for package in "${pip_packages[@]}"; do
    if python3 -m pip show "$package" &>/dev/null; then
        echo -e "${GREEN}✓ $package${NC}"
    else
        echo -e "${RED}✗ $package not found${NC}"
    fi
done

# Check LuaRocks packages
echo -e "\n${YELLOW}Checking LuaRocks packages...${NC}"
luarocks_packages=(
    "luacheck"
)

for package in "${luarocks_packages[@]}"; do
    if luarocks list | grep -q "^$package "; then
        echo -e "${GREEN}✓ $package${NC}"
    else
        echo -e "${RED}✗ $package not found${NC}"
    fi
done

# Check stylua
echo -e "\n${YELLOW}Checking stylua...${NC}"
if command -v stylua &> /dev/null; then
    echo -e "${GREEN}✓ stylua${NC}"
else
    echo -e "${RED}✗ stylua not found${NC}"
fi

# Check Rust installation
echo -e "\n${YELLOW}Checking Rust installation...${NC}"
if command -v rustc &>/dev/null; then
    echo -e "${GREEN}✓ Rust${NC}"
else
    echo -e "${RED}✗ Rust not found${NC}"
fi

# Check CodeLLDB installation
echo -e "\n${YELLOW}Checking CodeLLDB installation...${NC}"
CODELDB_DIR="$HOME/.local/share/nvim/mason/packages/codelldb"
CODELDB_ADAPTER="$CODELDB_DIR/extension/adapter/codelldb"
CODELDB_LIBRARY="$CODELDB_DIR/extension/adapter/libcodelldb.dylib"

if [ -f "$CODELDB_ADAPTER" ] && [ -f "$CODELDB_LIBRARY" ]; then
    echo -e "${GREEN}✓ CodeLLDB is installed correctly${NC}"
    echo -e "${GREEN}  - Adapter: $CODELDB_ADAPTER${NC}"
    echo -e "${GREEN}  - Library: $CODELDB_LIBRARY${NC}"
else
    echo -e "${RED}✗ CodeLLDB installation is incomplete${NC}"
    if [ ! -f "$CODELDB_ADAPTER" ]; then
        echo -e "${RED}  - Missing adapter: $CODELDB_ADAPTER${NC}"
    fi
    if [ ! -f "$CODELDB_LIBRARY" ]; then
        echo -e "${RED}  - Missing library: $CODELDB_LIBRARY${NC}"
    fi
fi

# Clean up Homebrew
echo -e "\n${YELLOW}Cleaning up Homebrew...${NC}"
brew cleanup

# Print summary
echo -e "\n${YELLOW}Summary:${NC}"
echo -e "${GREEN}✓ Homebrew packages${NC} - Required for various Neovim features"
echo -e "${GREEN}✓ Node.js packages${NC} - Required for JavaScript/TypeScript development"
echo -e "${GREEN}✓ Python packages${NC} - Required for Python development"
echo -e "${GREEN}✓ LuaRocks packages${NC} - Required for Lua development"
echo -e "${GREEN}✓ stylua${NC} - Required for Lua formatting"
echo -e "${GREEN}✓ Rust${NC} - Required for Rust development"
echo -e "${GREEN}✓ CodeLLDB${NC} - Required for Rust debugging in Neovim"

echo -e "\n${GREEN}Cleanup complete!${NC}"
echo -e "${YELLOW}Note: To completely remove all development tools, run:${NC}"
echo "brew uninstall ${brew_packages[*]}"
echo "npm uninstall -g ${npm_packages[*]}"
echo "pip3 uninstall ${pip_packages[*]}"
echo "luarocks remove ${luarocks_packages[*]}"
echo "cargo uninstall stylua"
echo "brew uninstall rust llvm@19"
echo "rm -rf $CODELDB_DIR" 