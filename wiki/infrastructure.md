# Infrastructure Scripts

This document describes the infrastructure scripts used in the Neovim configuration. For contribution guidelines, please refer to [CONTRIBUTING.md](../CONTRIBUTING.md).

## Core Scripts

### Installation and Setup

- `install.sh`: Main installation script for macOS that sets up the Neovim environment
  - Installs system dependencies via Homebrew
  - Sets up Python packages
  - Installs Node.js and npm packages
  - Installs Rust and related tools
  - Configures tmux

- `install.ps1`: Main installation script for Windows that sets up the Neovim environment
  - Supports both winget (default) and Chocolatey package managers
  - Installs system dependencies via selected package manager
  - Sets up Python packages
  - Installs Node.js and npm packages
  - Installs Rust and related tools
  - Configures tmux

### Package Management

- `packages/`: Directory containing package installation scripts
  - `brew.sh`: Homebrew package installation (macOS)
  - `npm.sh`: Node.js package installation
  - `cargo.sh`: Rust package installation
  - `pip.sh`: Python package installation
  - `luarocks.sh`: Lua package installation
  - `nvim.sh`: Neovim configuration installation

- `packages.sh`: Main package management script that orchestrates the installation of all packages
- `should_run_tests.sh`: Determines if tests should run based on changed files
- `codelldb.sh`: Sets up CodeLLDB for debugging support

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

```bash
### Installation
./infra/install.sh
```

```bash
### Docker Setup
./infra/docker.sh [--local]
```

```bash
### Cleanup
./infra/cleanup.sh
```

```bash
### Formatting
./infra/format_lua.sh
```

```bash
### Testing
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

4. Security:
   - CodeQL analysis for security vulnerabilities
   - Secret scanning for sensitive information
   - Weekly automated security checks
   - Compressed security scan artifacts

## Error Handling

All scripts use the error handling utilities from `lib.sh`:

- Proper exit code handling
- Error message formatting
- Logging to appropriate channels
- Automatic retry mechanisms for package installation

## Cache Management

The CI workflow uses caching for:

1. Package Manager:
   - Homebrew packages (macOS)
     - Supports both Intel and Apple Silicon paths
     - Architecture-specific cache keys
     - Automatic cache restoration
   - Chocolatey packages (Windows)
     - System-wide package cache
     - Automatic cache restoration
     - Version-specific caching

2. Language-specific packages:
   - npm packages
   - Cargo packages
   - pip packages
   - LuaRocks packages

3. Artifacts:
   - Compressed test results
   - Compressed security scan results
   - Compressed build artifacts

## Platform Support

Currently supported platforms:

- macOS (Intel and Apple Silicon)
  - Uses Homebrew for package management
  - Native system integration
- Windows
  - Uses winget by default for package management
  - Chocolatey support integrated into install.ps1
  - PowerShell-based automation
- Docker container for cross-platform development
