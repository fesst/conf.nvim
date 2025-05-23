# Vim lua config

## General repo rules

Lazy is package manager.


### File structure


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
- test/setup/sanity_nvim_start.sh contains automated tests organized into functions:
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

- `cleanup.sh`: Removes all installed components in reverse order:
  - Python packages
  - Rust packages
  - Node.js packages
  - System packages
  - Neovim configuration

- `format.sh`: Code quality script that:
  - Installs and runs `stylua` for Lua formatting
  - Installs and runs `luacheck` for Lua linting
  - Cleans up whitespace and formatting issues

- `lib.sh`: Shared functions and variables used by other scripts:
  - Common installation functions
  - Version checks
  - Error handling
  - Platform detection

##### CI/CD

- All CI (GitHub Actions) must only run scripts that are present in the repository (e.g., infra/install.sh, test/setup/sanity_nvim_start.sh).
- Do not use raw shell commands directly in the workflow YAML; always invoke scripts from the repo.
- This ensures reproducibility, security, and easier local testing.

###### Workflows
- CodeQL Analysis (`.github/workflows/codeql.yml`):
  - Analyzes GitHub Actions workflows for security
  - Runs on:
    - Push to master
    - Pull requests to master
    - Weekly (Mondays at 12:33 UTC)
  - Uses security-extended query pack
  - Requires permissions:
    - security-events: write
    - packages: read
    - actions: read
    - contents: read

- Lua Analysis (`.github/workflows/lua-analysis.yml`):
  - Analyzes Lua code using luacheck
  - Runs on:
    - Push to master
    - Pull requests to master
    - Weekly (Mondays at 12:33 UTC)
  - Installs:
    - Lua 5.4
    - LuaRocks
    - luacheck
  - Analyzes:
    - lua/ directory
    - after/plugin/ directory
  - Uses:
    - --codes: Shows warning codes
    - --ranges: Shows line and column ranges
    - --formatter plain: Uses plain text output

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
- Run sanity tests (test/setup/sanity_nvim_start.sh) after making changes to verify basic functionality.


## VCS

- pushall means:
add everything, read and summarize and then commit and push. One-line command is preferrable choice until there are reasons to separate.


## null-ls specialty (important)

- **null-ls.nvim** is a Neovim plugin that acts as a bridge between external formatters/linters and the built-in LSP client. It is **not** a language server itself and should **not** be set up via `lspconfig` as a server.
- All null-ls configuration should be placed in `after/plugin/` (e.g., `after/plugin/null-ls.lua`).
- Do **not** attempt to register null-ls as an LSP server in `lspconfig`.
- This specialty is important for avoiding misconfiguration and errors.
