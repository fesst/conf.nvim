# Neovim Key Mappings

## Overridden Default Mappings
- `K` - Hover documentation (overrides default help lookup)
- `gd` - Go to definition (overrides default goto declaration)
- `<C-e>` - Toggle harpoon quick menu (overrides default scroll down)

## Folding Strategy
- Uses LSP-based folding with Treesitter fallback for all languages
- Folding is based on semantic code structure rather than indentation
- All folds are open by default (foldlevel = 99)
- Fold column width is set to 4 characters
- Minimum 1 line required for a fold
- Maximum fold nesting level is 20

## File Explorer (NvimTree)
- `<leader>pv` - Open NvimTree and find current file
- `<leader>p-` - Toggle NvimTree

## File Search (Telescope)
- `<leader>tf` - Find files
- `<leader>te` - Find recently opened files
- `<leader>ts` - Search for string
- `<leader>tg` - Find git files
- `<leader>tl` - Live grep
- `<leader>th` - Search help tags

## File Navigation (Harpoon)
- `<leader>a` - Add file to harpoon
- `<C-e>` - Toggle harpoon quick menu
- `<leader>g1` to `<leader>g9` - Navigate to harpooned files 1-9

## LSP Mappings
- `gd` - Go to definition
- `K` - Hover documentation
- `<leader>ca` - Code actions
- `<leader>rn` - Rename symbol
- `<leader>f` - Format document
- `<leader>e` - Show diagnostic float
- `[i` - Previous diagnostic
- `]i` - Next diagnostic

## Debug (DAP) Mappings
- `<leader>dc` - Start/Continue debugging
- `<leader>di` - Step into
- `<leader>do` - Step over
- `<leader>du` - Step out
- `<leader>db` - Toggle breakpoint
- `<leader>dB` - Set conditional breakpoint
- `<leader>dl` - Set log point
- `<leader>dr` - Open REPL
- `<leader>dL` - Run last debug configuration

## Git (Fugitive)
- `<leader>gs` - Git status

## Undo Tree
- `<leader>u` - Toggle undotree

## Copilot
- `<leader>cp` - Open Copilot panel
- `<C-.>` - Next suggestion
- `<C-,>` - Previous suggestion
- `<C-\>` - Dismiss suggestion
- `<C-CR>` - Accept suggestion (inserts newline after accepting)

## Language-Specific Mappings

### Run/Test Commands
- `<leader>yr` - Run current file/project
- `<leader>yt` - Run tests

### Python
- `<leader>yr` - Run Python file
- `<leader>yt` - Run Python tests

### Go
- `<leader>yr` - Run Go file
- `<leader>yt` - Run Go tests

### Rust
- `<leader>yr` - Run Rust project
- `<leader>yt` - Run Rust tests

### JavaScript/TypeScript
- `<leader>yr` - Run JavaScript file
- `<leader>yt` - Run npm tests

### LaTeX
- `<leader>yb` - Build LaTeX document
- `<leader>yv` - View LaTeX PDF

### Docker
- `<leader>yd` - Build Docker image
- `<leader>yr` - Run Docker container

## Angular-Specific Mappings
- `<leader>saf` - Find Angular Component
- `<leader>sag` - Search in Angular App
- `<leader>gac` - Generate Angular Component
- `<leader>gas` - Generate Angular Service
- `<leader>gam` - Generate Angular Module

## Language-Specific Settings

### Python
- Tab size: 4
- Expand tabs: Yes
- Text width: 88 (Black formatter default)
- Folding: LSP/Treesitter-based

### JavaScript/TypeScript
- Tab size: 2
- Expand tabs: Yes
- Folding: LSP/Treesitter-based

### HTML/CSS
- Tab size: 2
- Expand tabs: Yes
- Folding: LSP/Treesitter-based

### Go
- Tab size: 4
- Expand tabs: No
- Folding: LSP/Treesitter-based

### C/C++
- Tab size: 4
- Expand tabs: Yes
- Folding: LSP/Treesitter-based

### Rust
- Tab size: 4
- Expand tabs: Yes
- Color column: 100
- Text width: 100
- Format options: cqrnj
- Folding: LSP-based

### LaTeX
- Text width: 80
- Word wrap enabled
- Folding: LSP/Treesitter-based

### Shell Scripts
- Folding: LSP/Treesitter-based

### JSON/YAML/TOML
- Folding: LSP/Treesitter-based

### Markdown and Text Files
- Folding: LSP/Treesitter-based

## Supported Languages
- Python (LSP: pyright, DAP: debugpy)
  - Tab size: 4 spaces
  - Text width: 88 (Black formatter default)
  - Folding: LSP/Treesitter-based
- JavaScript/TypeScript (LSP: tsserver, DAP: node-debug2)
  - Tab size: 2 spaces
  - Folding: LSP/Treesitter-based
- Go (LSP: gopls, DAP: delve)
  - Tab size: 4 spaces (no expandtab)
  - Folding: LSP/Treesitter-based
- Rust (LSP: rust-analyzer, DAP: codelldb)
  - Tab size: 4 spaces
  - Folding: LSP/Treesitter-based
- C/C++ (LSP: clangd, DAP: codelldb)
  - Tab size: 4 spaces
  - Folding: LSP/Treesitter-based
- Java/Kotlin (LSP: jdtls)
  - Folding: LSP/Treesitter-based
- Elixir (LSP: elixirls, DAP: elixir-ls)
  - Folding: LSP/Treesitter-based
- C# (LSP: omnisharp, DAP: netcoredbg)
  - Folding: LSP/Treesitter-based
- Zig (LSP: zls, DAP: zls)
  - Folding: LSP/Treesitter-based
- Lua (LSP: lua_ls, DAP: nlua)
  - Folding: LSP/Treesitter-based
- PHP (LSP: intelephense, DAP: xdebug)
  - Folding: LSP/Treesitter-based
- Ruby (LSP: solargraph, DAP: rdbg)
  - Folding: LSP/Treesitter-based
- HTML/CSS/SCSS/Less
  - Tab size: 2 spaces
  - Folding: LSP/Treesitter-based
- JSON/YAML/TOML
  - Folding: LSP/Treesitter-based
- Markdown
  - Folding: LSP/Treesitter-based
- Shell scripts (sh, bash, zsh)
  - Folding: LSP/Treesitter-based
- LaTeX
  - Text width: 80
  - Word wrap enabled
  - Folding: LSP/Treesitter-based

## Plugin Mappings
*(More mappings to be added as we configure more plugins)* 