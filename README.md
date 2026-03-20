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
- **Persistent folding state** - automatically saves and restores fold state between sessions.
- Various custom settings and mappings (with focus on preservation compatibility with help).
- Installation scripts for macOS ([brew](https://brew.sh/)) and Windows (`winget` or Chocolatey).
- GitHub Actions CI with:
  - Native macOS and Windows sanity runs on a single runner per platform
  - Toolchain/bootstrap caching for Python, npm, Cargo, and Neovim plugin state
  - Security scanning with CodeQL (GitHub Actions) and Trivy
  - Docker image builds for `amd64` and `arm64`
  - Cleanup of stale workflow runs

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

   On macOS the script uses Homebrew. On Windows it can use `winget` or Chocolatey.

The installation script will:

- Install required system dependencies via Homebrew (macOS) or winget/Chocolatey (Windows)
- Create or reuse a Python virtual environment
- Install Python, npm, Cargo, and LuaRocks packages needed by the config
- Bootstrap the pinned Neovim plugin set

## Debugging Setup

### Rust/C++ Debugging

- Uses CodeLLDB for debugging Rust and C++ code.
- Can be installed with [`infra/codelldb.sh`](infra/codelldb.sh) when needed.
- Requires LLVM tooling for proper functionality.

### Python Debugging

- Python DAP support is not bootstrapped by the current installer path.
- Enable and install adapters explicitly if you restore the discharged Python DAP config.

### Go Debugging

- Go DAP support is currently discharged and not installed by default.

## Key Mappings

[Custom mappings within current configuration](ordered_mappings.md)

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

- [Key Mappings](ordered_mappings.md)
- [Contribution Guide](CONTRIBUTING.md)
- [`infra/`](infra) for installer and CI entry points
- [`test/`](test) for local validation fixtures

## Local Validation

Run the standard sanity check:

```bash
./infra/nvim_sanity_test.sh
```

For a lightweight smoke test during refactors:

```bash
nvim --headless '+qa'
```

## Project Structure

``` .
.
├── after/          # Plugin configurations
├── infra/          # Installation scripts
├── lua/            # Lua configurations and shared helpers
│   └── motleyfesst/
│       └── utils/  # Shared helper modules used by plugin and core config
├── ordered_mappings.md  # Key mapping reference
└── test/                # Test files
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

## Contributing

Please see [CONTRIBUTING.md](CONTRIBUTING.md) for detailed guidelines on how to contribute to this project.

Note: When contributing, please ensure your changes work on both macOS and Windows environments. The CI pipeline includes automated tests for both platforms, using Homebrew for macOS and winget/Chocolatey for Windows package management.
