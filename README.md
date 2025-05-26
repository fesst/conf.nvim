# Neovim Configuration

A modern Neovim configuration with a focus on development productivity and debugging capabilities, supporting both macOS and Windows platforms.

## Quick Start

### Plugins

Installed with [lazy.nvim](https://github.com/folke/lazy.nvim)

- **Language Support**: Comprehensive support for multiple programming languages.
- **Debugging**: Integrated debugging support with DAP (Debug Adapter Protocol).
- **LSP**: Language Server Protocol support for intelligent code completion.
- **Telescope**: Fuzzy finding and searching capabilities.
- **Treesitter**: Advanced syntax highlighting and code navigation.
- **Mason**: Automatic language server and debugger installation.
- **UndoTree**: infinite undo/redo tree with support of keeping the tree on buffer close (potentially infinitely).
- **Fugitive**: simple git integration.
- **Harpoon**: ThePrimeAgen plugin for quick file hooks.
- **NvimTree** as a less buggy project view with tree-view support (netrw is buggy in such mode at the moment of setting things up).
- **Rose Pine alt** as a color theme.
- **Lualine**: status line, aligned with main color theme.

To list the GitHub repositories of the installed plugins, run:

```sh
grep "\".*/.*\"" lua/motleyfesst/lazy.lua | sed 's/dependencies = {\(.*\) }/\1/g' | sort | uniq
```

### Settings and CI

- Autofolding for multiple languages (using LSP and treesitter, except indent for python).
- Various custom settings and mappings (with focus on preservation compatibility with help).
- Installation script for MacOS ([brew](https://brew.sh/)).
- GitHub Actions CI with:
  - Automated environment setup with cross-platform support (macOS and Windows)
  - Virtual environment management for Python dependencies
  - Sanity check tests
  - Lua code analysis
  - Security scanning
  - Docker image building
  - Automated cleanup of old workflow runs
  - Manual check still required for all features
  - Efficient caching strategy for:
    - Python virtual environments
    - Homebrew packages (macOS)
    - Chocolatey packages (Windows)
    - Node.js packages
    - Rust packages
    - LuaRocks packages
    - Neovim plugins

## Installation

1. Clone this repository:

   ```bash
   git clone https://github.com/fesst/conf.nvim.git ~/.config/nvim
   ```

2. Run the installation script:

   For macOS:

   ```zsh
   ./infra/install.sh
   ```

   For Windows:

   ```powershell
   # Using winget (default)
   .\infra\install.ps1

   # Using Chocolatey
   .\infra\install.ps1 -UseChocolatey
   ```

   Note: The installation script supports both macOS and Windows environments. On macOS, it uses Homebrew for package management, while on Windows it uses winget by default with Chocolatey as an optional alternative.

The installation script will:

- Install required system dependencies via Homebrew (macOS) or winget/Chocolatey (Windows)
- Set up Python packages
- Install Node.js and npm packages
- Install Rust and related tools
- Install CodeLLDB for Rust/C++ debugging
- Configure tmux

## Debugging Setup

### Rust/C++ Debugging

- Uses CodeLLDB for debugging Rust and C++ code.
- Automatically installed in `~/.local/share/nvim/mason/packages/codelldb`.
- Requires LLVM 19 for proper functionality.

### Python Debugging

- Uses debugpy for Python debugging.
- Automatically installed through Mason.

### Go Debugging

- Uses Delve for Go debugging.
- Installed via Homebrew.

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

## Documentation

- [Project rules](wiki/ai_context.md)
  e.g. CI should use infra scripts as much as possible to have a single source of truth for CI and local pipeline.
- [Infrastructure description](wiki/infrastructure.md)
- [Key Mappings](wiki/mappings.md)
- [Docker Setup](wiki/docker.md)
- [Testing](wiki/tests.md)

## Project Structure

``` .
.
├── after/          # Plugin configurations
├── infra/          # Installation scripts
├── lua/            # Lua configurations
├── test/           # Test files
└── wiki/           # Documentation
```

## Requirements

### System Requirements

- macOS (tested on 24.5.0) or Windows
- Homebrew (macOS) or Chocolatey (Windows)
- Git

### Required Packages

- LLVM 19
- Rust
- Python 3
- Node.js
- tmux

For detailed information about dependencies and tools, see [Shared Tools](wiki/shared_tools.md).

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a new Pull Request

Note: When contributing, please ensure your changes work on both macOS and Windows environments. The CI pipeline includes automated tests for both platforms, using Homebrew for macOS and Chocolatey for Windows package management.
