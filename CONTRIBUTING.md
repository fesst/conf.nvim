# Contributing to Neovim Configuration

Thank you for your interest in contributing to this Neovim configuration project! This document provides guidelines and instructions for contributing.

## Development Environment

### Prerequisites

#### macOS

- Homebrew package manager
- Git
- Python 3
- Node.js
- Rust
- LLVM 19

#### Windows

- Git
- Python 3
- Node.js
- Rust
- LLVM 19
- Either:
  - winget (default, recommended)
  - Chocolatey (alternative)

### Setup

1. Fork and clone the repository:

   ```bash
   git clone https://github.com/YOUR_USERNAME/conf.nvim.git ~/.config/nvim
   ```

2. Install dependencies:
   - macOS:

     ```zsh
     ./infra/install.sh
     ```

   - Windows:

     ```powershell
     # Using winget (default)
     .\infra\install.ps1

     # Using Chocolatey
     .\infra\install.ps1 -UseChocolatey
     ```

## Development Guidelines

### Code Structure

- Plugin configurations should be in `after/plugin/`
- General configurations should be in `lua/motleyfesst/`
- Infrastructure scripts should be in `infra/`
- Documentation should be in `wiki/`

### Lua Code Style

- Follow the existing code style
- Use `stylua` for formatting
- Document complex functions and configurations
- Keep related functionality together
- Place plugin setups in `after/plugin/`

### Testing

1. Run the sanity tests:

   ```bash
   ./infra/nvim_sanity_test.sh
   ```

2. Test on both platforms:
   - macOS: Use the bash scripts
   - Windows: Use the PowerShell scripts

3. Verify LSP functionality:
   - Test with the sample files in `test/`
   - Check language server installation
   - Verify debugging capabilities

### Documentation

1. Update relevant documentation:
   - README.md for major changes
   - wiki/ for detailed documentation
   - CONTRIBUTING.md if contributing guidelines change

2. Document all non-default key mappings in `wiki/mappings.md`

3. Update infrastructure documentation if changing:
   - Installation scripts
   - CI/CD workflows
   - Package management

## Pull Request Process

1. Create a feature branch:

   ```bash
   git checkout -b feature/your-feature-name
   ```

2. Make your changes:
   - Follow the code style
   - Add tests if applicable
   - Update documentation

3. Run tests:

   ```bash
   ./infra/nvim_sanity_test.sh
   ```

4. Commit your changes:

   ```bash
   git commit -m "feat: your feature description"
   ```

5. Push to your fork:

   ```bash
   git push origin feature/your-feature-name
   ```

6. Create a Pull Request:
   - Use the PR template
   - Describe your changes
   - Reference any related issues
   - Ensure CI passes

## CI/CD

The project uses GitHub Actions for CI/CD. All changes must:

1. Pass all tests on both platforms:
   - macOS (using Homebrew)
   - Windows (using winget)

2. Meet code quality standards:
   - Lua code analysis
   - Security scanning
   - Documentation checks

3. Follow the caching strategy:
   - Python virtual environments
   - Package manager caches
   - Language-specific package caches

## Package Management

### macOS

- Use Homebrew for system packages
- Follow the order in `infra/install.sh`

### Windows

- Prefer winget for system packages
- Use Chocolatey as a fallback
- Follow the order in `infra/install.ps1`

## Getting Help

- Check existing documentation in `wiki/`
- Review open and closed issues
- Ask in discussions if needed

## Code of Conduct

- Be respectful and inclusive
- Focus on the technical aspects
- Help others when possible
- Accept constructive criticism

Thank you for contributing to making this Neovim configuration better!
