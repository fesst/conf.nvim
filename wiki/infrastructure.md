# Infrastructure Scripts

This document describes the infrastructure scripts used in the Neovim configuration.

## Core Scripts

### Installation and Setup

- `install.sh`: Main installation script that sets up the Neovim environment
  - Installs system dependencies via Homebrew
  - Sets up Python packages
  - Installs Node.js and npm packages
  - Installs Rust and related tools
  - Configures tmux

- `packages.sh`: Manages package installations
  - Handles Homebrew package installation
  - Manages Python package installation
  - Sets up Node.js packages

- `codelldb.sh`: CodeLLDB installation and setup
  - Installs CodeLLDB for Rust/C++ debugging
  - Configures LLVM 19 integration

### Docker Support

- `docker.sh`: Docker environment management
  - Builds and runs the Docker container
  - Supports both local and remote builds
  - Manages container lifecycle

### Maintenance

- `cleanup.sh`: System cleanup script
  - Removes installed packages
  - Cleans up configuration files
  - Restores system to pre-installation state

- `format_lua.sh`: Lua code formatting
  - Uses stylua for formatting
  - Applies project-specific formatting rules
  - Integrates with CI/CD pipeline

### Utility Scripts

- `lib.sh`: Shared library functions
  - Common shell functions
  - Error handling utilities
  - Logging functions

- `example.sh`: Example script template
  - Basic script structure
  - Common patterns
  - Best practices

- `gh_example.sh`: GitHub Actions example
  - Workflow templates
  - CI/CD patterns
  - Testing examples

## Usage

### Installation

```bash
./infra/install.sh
```

### Docker Setup

```bash
./infra/docker.sh [--local]
```

### Cleanup

```bash
./infra/cleanup.sh
```

### Formatting

```bash
./infra/format_lua.sh
```

## Integration with CI/CD

The infrastructure scripts are integrated with the CI/CD pipeline:

1. `format_lua.sh` is used in the Lua analysis workflow
2. `docker.sh` is used for container testing
3. `lib.sh` provides common functions for CI scripts

## Error Handling

All scripts use the error handling utilities from `lib.sh`:

- Proper exit code handling
- Error message formatting
- Logging to appropriate channels

## Contributing

When adding new infrastructure scripts:

1. Follow the patterns in `example.sh`
2. Use functions from `lib.sh`
3. Include proper error handling
4. Add documentation to this file
