# Neovim Configuration

A modern Neovim configuration with a focus on development productivity and debugging capabilities with MacOS-specific installation script.

## Features

### Plugins

Installed with [lazy.nvim](https://github.com/folke/lazy.nvim)

- **Language Support**: Comprehensive support for multiple programming languages
- **Debugging**: Integrated debugging support with DAP (Debug Adapter Protocol)
- **LSP**: Language Server Protocol support for intelligent code completion
- **Telescope**: Fuzzy finding and searching capabilities
- **Treesitter**: Advanced syntax highlighting and code navigation
- **Mason**: Automatic language server and debugger installation
- **Fugitive** simple git integration
- **Harpoon** ThePrimeAgen plugin for quick file hooks
- **NvimTree** as a less buggy project view wtih tree-view support (netrw is buggy in such mode at the moment of setting things up)

### Setup

- Autofolding for multiple languages
- Github actions CI with sanity check test (but still requires manual check)
- Various custom mappings settings

## Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/conf.nvim.git ~/.config/nvim
   ```

2. Run the installation script:
   ```bash
   ./infra/install.sh
   ```

The installation script will:
- Install required system dependencies via Homebrew
- Set up Python packages
- Install Node.js and npm packages
- Install Rust and related tools
- Install CodeLLDB for Rust/C++ debugging
- Configure tmux

## Debugging Setup

### Rust/C++ Debugging
- Uses CodeLLDB for debugging Rust and C++ code
- Automatically installed in `~/.local/share/nvim/mason/packages/codelldb`
- Requires LLVM 19 for proper functionality

### Python Debugging
- Uses debugpy for Python debugging
- Automatically installed through Mason

### Go Debugging
- Uses Delve for Go debugging
- Installed via Homebrew

## Key Mappings

[Custom mappings within current configuration](wiki/mappings.md)

### Debugging
- `<leader>dc` - Start/Continue debugging
- `<leader>di` - Step into
- `<leader>do` - Step over
- `<leader>du` - Step out
- `<leader>db` - Toggle breakpoint
- `<leader>dB` - Set conditional breakpoint
- `<leader>dl` - Set log point
- `<leader>dr` - Open REPL
- `<leader>dL` - Run last

### Language-specific
- `<leader>yr` - Run current file
- `<leader>yt` - Run tests

## Maintenance

### Cleanup
To clean up the installation:
```bash
./infra/cleanup.sh
```

This will:
- Check and maintain required LLVM version
- Verify Rust installation
- Check CodeLLDB installation
- Clean up Homebrew packages

### Complete Removal
To completely remove development tools:
```bash
brew uninstall rust llvm@19
rm -rf ~/.local/share/nvim/mason/packages/codelldb
```

## Directory Structure

```
.
├── after/          # Plugin configurations
├── infra/          # Installation and maintenance scripts
├── lua/            # Lua configurations
│   └── motleyfesst/ # Core configuration
└── wiki/           # Documentation and notes
```

## Dependencies

### System Requirements
- macOS (tested on 24.5.0)
- Homebrew
- Git

### Required Packages
- LLVM 19
- Rust
- Python 3
- Node.js
- tmux

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a new Pull Request
