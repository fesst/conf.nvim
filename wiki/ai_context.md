# Vim lua config

## General repo rules

Lazy is package manager.

### File structure

#### Root level files

Documentation:

- `README.md`: Main project documentation and quick start guide
- `CONTRIBUTING.md`: Detailed contribution guidelines and development setup
- `LICENSE`: Project license (MIT)

Configuration:

- `.github/`: GitHub-specific configurations and workflows
- `infra/`: Installation and infrastructure scripts
- `test/`: Test files and applications
- `wiki/`: Detailed documentation
- `Dockerfile.arm64`: Container definition for ARM64 architecture
- `Dockerfile.amd64`: Container definition for AMD64 architecture
- `.dockerignore`: Docker build exclusions
- `.gitignore`: Git exclusions
- `.stylua.toml`: Lua code formatting rules
- `.luacheckrc`: Lua code linting rules
- `.luarc.json`: Lua language server configuration
- `.cursorrc`: Cursor IDE configuration
- `.cursorignore`: Cursor IDE exclusions
- `lazy-lock.json`: Lazy.nvim plugin lock file
- `init.lua`: Neovim initialization file
- `after/`: Plugin configurations
- `lua/`: Lua configurations
- `.venv/`: Python virtual environment (gitignored)

#### Lua files structure

- Plugins setup should be in after/plugin (that is important path!)
- General should be in lua/motleyfesst

##### New lua files rules

- All plugin setup should be in after/plugin. Including their keymappings.
- We think that related functionality is better to place altogether. But if makes sense, we can separate, like we did with lsp.lua and languages.lua.
- As a rule of thumb it is better to place something to comply with already presented structure. If it is vague or/and unexplained — we need to update this file first to be on the same page before proceeding.

#### Wiki

- We have to document groupped information about all mappings we set up in wiki/mappings.md.
- Especially document all overridden (but only non-default!) mappings in wiki/mappings.md.
- Highlight which defaults are overriden and propose solutions immediately as soon as conflicts should be avoided with the exception of more sophisticated functionality with similar usage.

#### Test apps

- test/ folder contains some test lua scripts and test applications to check LSP and DAP functionality.
- infra/nvim_sanity_test.sh contains automated tests organized into functions:
  - test_basic_functionality(): Basic Neovim operations (startup, file opening)
  - test_health_check(): Runs checkhealth and verifies output
  - test_core_plugins(): Verifies loading of core plugins (Lazy, Treesitter, LSP, Mason, Telescope)
  - test_treesitter(): Checks Treesitter functionality and status
  - test_harpoon(): Verifies Harpoon plugin loading and mark functionality
  - test_postgres(): Tests PostgreSQL/SQL LSP loading and configuration
  - cleanup(): Handles test file cleanup
  These tests run in headless mode and will fail if any critical functionality is broken.
  Each function is self-contained and can be run independently if needed.

#### Infrastructure

- Additional installation scripts should be in infra/ folder.

- All settings that should be installed separately from lazy should be prioritized like this:
  - brew packages
  - npm packages
  - cargo packages
  - pip packages

- Any installation should be done via infra/install.sh and synced in infra/cleanup.sh.

- Duplication in install.sh and cleanup.sh should be avoided by putting it into lib.sh.
- We do not support cross-platform for now.

##### Infrastructure Scripts

- `install.sh`: Main installation script that sets up all dependencies in order:
  - System packages (brew)
  - Node.js packages (npm)
  - Rust packages (cargo)
  - Python packages (pip)
  - Neovim configuration
  - Language servers and tools
  - Lua tools (stylua)
  - Neovim Mason packages

- `cleanup.sh`: Removes all installed components in reverse order:
  - Neovim Mason packages
  - Lua tools (stylua)
  - CodeLLDB
  - LuaRocks packages
  - Python packages
  - Rust and Cargo packages
  - Node.js and npm packages
  - Homebrew casks
  - Homebrew packages
  - Configuration files cleanup

- `docker.sh`: Docker container management script that:
  - Supports both ARM64 and AMD64 architectures
  - Uses Dockerfile.arm64 or Dockerfile.amd64 based on architecture
  - Creates persistent volumes for data storage
  - Handles local builds and GitHub Container Registry pulls
  - Container packages are managed through Dockerfiles and cleaned up automatically on container removal

- `format.sh`: Code quality script that:
  - Installs and runs `stylua` for Lua formatting
  - Installs and runs `luacheck` for Lua linting
  - Cleans up whitespace and formatting issues

- `lib.sh`: Shared functions and variables used by other scripts:
  - Common installation functions
  - Version checks
  - Error handling
  - Platform detection
  - Package management utilities

##### Package Management

- Package installation and cleanup are handled symmetrically:
  - `install.sh` and `cleanup.sh` use the same package collections from `packages.sh`
  - Both scripts use shared utility functions from `lib.sh`
  - Package removal follows the reverse order of installation
  - Each package type has corresponding install/uninstall functions

- Package Management Structure:
  - `packages/`: Directory containing package installation scripts
    - `brew.sh`: Homebrew package installation (macOS)
    - `npm.sh`: Node.js package installation
    - `cargo.sh`: Rust package installation
    - `pip.sh`: Python package installation
    - `luarocks.sh`: Lua package installation
    - `nvim.sh`: Neovim configuration installation
  - `packages.sh`: Main package management script that orchestrates all installations
  - `should_run_tests.sh`: Determines if tests should run based on changed files
  - `codelldb.sh`: Sets up CodeLLDB for debugging support

- Error Handling:
  - All scripts use error handling utilities from `lib.sh`
  - Proper exit code handling
  - Error message formatting
  - Logging to appropriate channels
  - Automatic retry mechanisms for package installation

- Cache Management:
  - Package Manager:
    - Homebrew packages (macOS)
      - Supports both Intel and Apple Silicon paths
      - Architecture-specific cache keys
      - Automatic cache restoration
  - Language-specific packages:
    - npm packages
    - Cargo packages
    - pip packages
    - LuaRocks packages

- Docker Integration:
  - Docker containers use the same package management system
  - Packages are installed during container build via Dockerfiles
  - Package cleanup is handled automatically on container removal
  - Persistent data is stored in Docker volumes
  - Container images are available for both ARM64 and AMD64 architectures

##### Platform Support

Currently supported platforms:

- macOS (Intel and Apple Silicon)
  - Uses Homebrew for package management
  - Native system integration
- Windows
  - Uses Chocolatey for package management
  - Combined installation of Neovim and tree-sitter
  - Automatic PATH updates and environment verification
  - Parallel package installation for better performance
- Docker container for cross-platform development

##### CI

- All CI (GitHub Actions) must only run scripts that are present in the repository (e.g., infra/install.sh, infra/nvim_sanity_test.sh).
- Do not use raw shell commands directly in the workflow YAML; always invoke scripts from the repo.
- This ensures reproducibility, security, and easier local testing.

###### Workflows

- Master CI (`.github/workflows/ci.yml`):
  - Main CI workflow that runs on:
    - Push to master
    - Pull requests to master
    - Weekly (Mondays at 12:33 UTC)
  - Uses reusable workflow for environment setup
  - Runs Neovim tests and analysis
  - Uploads test logs as artifacts with compression

- Setup Environment (`.github/workflows/setup-environment.yml`):
  - Reusable workflow for environment setup
  - Configurable setup for:
    - Python (virtual environment)
    - Rust
    - Node.js
    - Lua
  - Creates and configures virtual environment with consistent paths
  - Sets up environment variables for Python packages
  - Implements caching strategy for:
    - Python virtual environments
    - Homebrew packages (macOS)
    - Chocolatey packages (Windows)
    - Node.js packages
    - Rust packages
    - LuaRocks packages
    - Neovim plugins
  - Platform-specific optimizations:
    - Windows:
      - Combined Neovim and tree-sitter installation
      - Automatic PATH management
      - Installation verification
      - Parallel package installation
    - macOS:
      - Homebrew package management
      - Native system integration

- Neovim Tests (`.github/workflows/neovim-tests.yml`):
  - Optimized workflow that combines Lua analysis and Neovim testing
  - Runs on:
    - Push to master
    - Pull requests to master
    - Weekly (Mondays at 12:33 UTC)
  - Jobs:
    - `check-changes`: Early detection of test necessity
    - `test`: Combined job that runs:
      - Lua code analysis with luacheck
      - Neovim functionality tests
  - Caching strategy:
    - Homebrew packages (including Apple Silicon paths)
    - LuaRocks packages and server index
    - Neovim plugins
  - Performance optimizations:
    - Single job for all tests
    - Optimized package installation
    - Reduced redundant operations
  - Analyzes:
    - lua/ directory
    - after/plugin/ directory
  - Uses:
    - --codes: Shows warning codes
    - --ranges: Shows line and column ranges
    - --formatter plain: Uses plain text output
    - --no-doc: Faster LuaRocks installation
  - Cross-platform support:
    - Uses PowerShell Core (pwsh) for Windows compatibility
    - Handles virtual environment activation for both Windows and macOS
    - Uses platform-specific paths and commands

- Security Scanning (`.github/workflows/codeql.yml`):
  - CodeQL analysis for security vulnerabilities
  - Secret scanning for sensitive information
  - Runs on:
    - Push to master
    - Pull requests to master
    - Weekly (Mondays at 12:33 UTC)
  - Uploads results as compressed artifacts
  - Uses security-extended query suite for comprehensive analysis

###### Environment Setup

- Virtual Environment:
  - Created in `$GITHUB_WORKSPACE/.venv` or `$RUNNER_TOOL_CACHE/venv`
  - Environment variables set consistently:
    - VIRTUAL_ENV: Set via GITHUB_ENV
    - PYTHONPATH: Platform-specific paths
    - PIP_TARGET: Platform-specific paths
    - PIP_PREFIX: Platform-specific paths
  - Platform-specific handling:
    - Windows:
      - Uses PowerShell Core (pwsh)
      - Virtual environment in `$RUNNER_TOOL_CACHE\venv`
      - Activation via `Scripts\activate.ps1`
    - macOS:
      - Uses bash
      - Virtual environment in `$RUNNER_TOOL_CACHE/venv`
      - Activation via `bin/activate`
  - Robust error handling:
    - Verification of virtual environment creation
    - Verification of activation scripts
    - Fallback mechanisms for common locations
    - Detailed error reporting
  - Caching strategy:
    - Cached between workflow runs
    - Platform-specific cache keys
    - Automatic cache restoration
  - Output handling:
    - Uses GITHUB_OUTPUT for workflow outputs:
      - Virtual environment path for workflow steps
      - Test execution status
      - Change detection results
    - Uses GITHUB_ENV for environment variables:
      - VIRTUAL_ENV for Python environment
      - PYTHONPATH for Python module resolution
      - PIP_TARGET and PIP_PREFIX for package installation
    - Consistent path handling across platforms:
      - Windows: Uses PowerShell path format
      - macOS: Uses Unix path format
      - Automatic path normalization
    - Error handling:
      - Verification of output variables
      - Fallback mechanisms for missing outputs
      - Detailed error messages for debugging

###### Workflow Structure

- Main workflows:
  - `setup-environment.yml`: Core environment setup
  - `setup-environment-windows.yml`: Windows-specific setup
  - `setup-environment-macos.yml`: macOS-specific setup
  - `test-steps.yml`: Common test execution
  - `pr-windows-tests.yml`: Windows PR testing
  - `pr-macos-tests.yml`: macOS PR testing
  - `macos-neovim-tests.yml`: Neovim-specific tests
  - `codeql.yml`: Security scanning

- Workflow features:
  - Early change detection
  - Conditional test execution
  - Cross-platform support
  - Efficient caching
  - Robust error handling
  - Detailed logging
  - Automatic cleanup
  - Compressed artifacts
  - Security scanning

###### Lua Module Loading

- Module Structure:
  - Modules are located in `lua/` directory
  - Each module should be in its own subdirectory (e.g., `lua/motleyfesst/`)
  - Module files can be either direct Lua files or init.lua files
  - Package path must be set correctly in tests:

    ```lua
    package.path = package.path .. ";../lua/?.lua;../lua/?/init.lua"
    ```

  - Error handling should use pcall for module loading
  - Tests should provide clear error messages for debugging

###### Branch Protection

- Master branch is protected
- Requires:
  - CI status check to pass
  - Code scanning results from CodeQL
  - Changes must be made through pull requests
  - No direct pushes to master allowed
- Always create a branch before pushing. Use a naming convention such as `feature/`, `hotfix/`, or `bugfix/` to categorize branches based on their purpose.

## General remapping rules

- Group related mappings together with clear comments.
- Use descriptive comments for each mapping group.
- As a rule of thumb do not override default commands that have functionality.
  Reasoning is to easily work with help without remembering all the mappings, at least until it's going to become so, but with the exception of more sophisticated functionality with similar usage.
- Only encode actual remaps in remap.lua (do not remap defaults to themselves). Last state is setting leader. Propose thoroughly!

## Check issues actuality

- To get date, run shell command date.
- Note: All previously disabled language parsers (Angular, Dockerfile, Fennel, Groovy, LaTeX, Svelte, Vue) are now available and can be enabled. [Last checked: 2025-05-20]
- If there will be possibility to check it periodically with AI it would be cool but it is definitely not necessary to do every time.

## Testing after changes

- Always test install.sh on its change.
- Always test nvim configuration on nvim plugin changes, do it with --headless and do not forget to quit after if needed.
- Run sanity tests (infra/nvim_sanity_test.sh) after making changes to verify basic functionality.

## VCS

- pushall means:
add everything, read and summarize and then commit and push. One-line command is preferrable choice until there are reasons to separate.

## null-ls specialty (important)

- **null-ls.nvim** is a Neovim plugin that acts as a bridge between external formatters/linters and the built-in LSP client. It is **not** a language server itself and should **not** be set up via `lspconfig` as a server.
- All null-ls configuration should be placed in `after/plugin/` (e.g., `after/plugin/null-ls.lua`).
- Do **not** attempt to register null-ls as an LSP server in `lspconfig`.
- This specialty is important for avoiding misconfiguration and errors.
