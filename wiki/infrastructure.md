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

### Package Management

- `packages/`: Directory containing package installation scripts
  - `brew.sh`: Homebrew package installation
  - `npm.sh`: Node.js package installation
  - `cargo.sh`: Rust package installation
  - `pip.sh`: Python package installation
  - `luarocks.sh`: Lua package installation
  - `nvim.sh`: Neovim configuration installation

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

### Testing

- `nvim_sanity_test.sh`: Neovim configuration testing
  - Tests basic functionality
  - Verifies plugin loading
  - Checks LSP configuration
  - Validates debugging setup

### Utility Scripts

- `lib.sh`: Shared library functions
  - Common shell functions
  - Error handling utilities
  - Logging functions

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

### Testing

```bash
./infra/nvim_sanity_test.sh
```

## Integration with CI/CD

The infrastructure scripts are integrated with the CI/CD pipeline:

1. Package Management:
   - Separate scripts for each package manager
   - Automatic retry on failure
   - Cache management for faster builds

2. Testing:
   - Automated sanity tests
   - Plugin verification
   - LSP configuration checks

3. Environment Setup:
   - Virtual environment management
   - Cross-platform compatibility
   - Architecture-specific paths (Intel/Apple Silicon)

## Error Handling

All scripts use the error handling utilities from `lib.sh`:

- Proper exit code handling
- Error message formatting
- Logging to appropriate channels
- Automatic retry mechanisms for package installation

## Contributing

When adding new infrastructure scripts:

1. Place package-specific scripts in `packages/` directory
2. Use functions from `lib.sh`
3. Include proper error handling
4. Add documentation to this file
5. Update CI workflow if necessary

## Cache Management

The CI workflow uses caching for:

1. Homebrew packages:
   - Supports both Intel and Apple Silicon paths
   - Architecture-specific cache keys
   - Automatic cache restoration

2. Language-specific packages:
   - npm packages
   - Cargo packages
   - pip packages
   - LuaRocks packages

## Platform Support

Currently supported platforms:

- macOS (Intel and Apple Silicon)
- Docker container for cross-platform development
