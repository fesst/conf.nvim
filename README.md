# Neovim Configuration

A modern Neovim configuration with a focus on development productivity and debugging capabilities.

## Quick Start

```bash
# Clone and install
git clone https://github.com/yourusername/conf.nvim.git ~/.config/nvim
./infra/install.sh

# Or use Docker
./infra/docker.sh
```

## Features

- **Language Support**: LSP, Mason, Code completion, Java support
- **Debugging**: DAP, DAP UI, Virtual text
- **Code Quality**: Null-ls, Shell/Lua formatting
- **Navigation**: Telescope, Harpoon, NvimTree
- **Version Control**: Git integration
- **UI**: Rose Pine theme, Lualine, Devicons
- **Productivity**: GitHub Copilot, UndoTree

## Documentation

- [Installation Guide](wiki/installation.md)
- [Key Mappings](wiki/mappings.md)
- [Docker Setup](wiki/docker.md)
- [Testing](wiki/tests.md)
- [CI/CD](wiki/ci.md)
- [Cleanup](wiki/cleanup.md)

## Project Structure

```
.
├── after/          # Plugin configurations
├── infra/          # Installation scripts
├── lua/            # Lua configurations
├── test/           # Test files
└── wiki/           # Documentation
```

## Requirements

- macOS (tested on 24.5.0)
- Homebrew
- Git
- LLVM 19
- Rust
- Python 3
- Node.js
- tmux

For detailed information about dependencies and tools, see [Shared Tools](wiki/shared_tools.md).
