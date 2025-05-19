# Neovim Key Mappings

## Overridden Default Mappings
- `K` - Hover documentation (overrides default help lookup)
- `gd` - Go to definition (overrides default goto declaration)

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
- `<C-e>` - Toggle harpoon quick menu (overrides default scroll down)
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
- `<leader>yt` - Run JavaScript tests

### Angular
- `<leader>saf` - Find Angular Component
- `<leader>sag` - Search in Angular App
- `<leader>gac` - Generate Angular Component
- `<leader>gas` - Generate Angular Service
- `<leader>gam` - Generate Angular Module

### LaTeX
- `<leader>yb` - Build LaTeX document
- `<leader>yv` - View LaTeX PDF

### Docker
- `<leader>yd` - Build Docker image
- `<leader>yr` - Run Docker container

## Supported Languages
- Python (LSP: pyright, DAP: debugpy)
- JavaScript/TypeScript (LSP: tsserver, DAP: node-debug2)
- Go (LSP: gopls, DAP: delve)
- Rust (LSP: rust-analyzer, DAP: codelldb)
- C/C++ (LSP: clangd, DAP: codelldb)
- Java/Kotlin (LSP: jdtls)
- Elixir (LSP: elixirls, DAP: elixir-ls)
- C# (LSP: omnisharp, DAP: netcoredbg)
- Zig (LSP: zls, DAP: zls)
- Lua (LSP: lua_ls, DAP: nlua)
- PHP (LSP: intelephense, DAP: xdebug)
- Ruby (LSP: solargraph, DAP: rdbg)
- HTML/CSS/SCSS/Less
- JSON/YAML/TOML
- Markdown
- Shell scripts (sh, bash, zsh)

## Plugin Mappings
*(More mappings to be added as we configure more plugins)* 