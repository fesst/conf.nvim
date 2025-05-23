# Neovim Key Mappings

## Overridden Default Mappings
- `K` - Hover documentation (overrides default help lookup)
- `gd` - Go to definition (overrides default goto declaration)
- `<C-e>` - Toggle harpoon quick menu (overrides default scroll down)

## Plugin Mappings

### Tree-sitter
#### Incremental Selection
- `gnn` - Start selection
- `grn` - Expand to next syntax node
- `grc` - Expand to next scope
- `grm` - Shrink to previous node

#### Text Objects
- `af` - Select outer function
- `if` - Select inner function
- `ac` - Select outer class
- `ic` - Select inner class

### File Explorer (NvimTree)
- `<leader>pv` - Open NvimTree and find current file
- `<leader>p-` - Toggle NvimTree

### File Search (Telescope)
- `<leader>tf` - Find files
- `<leader>te` - Find recently opened files
- `<leader>ts` - Search for string
- `<leader>tg` - Find git files
- `<leader>tl` - Live grep
- `<leader>th` - Search help tags

### File Navigation (Harpoon)
- `<leader>a` - Add file to harpoon
- `<C-e>` - Toggle harpoon quick menu
- `<leader>g1` to `<leader>g9` - Navigate to harpooned files 1-9

### LSP
- `gd` - Go to definition
- `K` - Hover documentation
- `<leader>ca` - Code actions
- `<leader>rn` - Rename symbol
- `<leader>f` - Format document
- `<leader>e` - Show diagnostic float
- `[i` - Previous diagnostic
- `]i` - Next diagnostic

### Debug (DAP)
- `<leader>dc` - Start/Continue debugging
- `<leader>di` - Step into
- `<leader>do` - Step over
- `<leader>du` - Step out
- `<leader>db` - Toggle breakpoint
- `<leader>dB` - Set conditional breakpoint
- `<leader>dl` - Set log point
- `<leader>dr` - Open REPL
- `<leader>dL` - Run last debug configuration

### Git (Fugitive)
- `<leader>gs` - Git status

### Undo Tree
- `<leader>u` - Toggle undotree

### Copilot
- `<leader>cp` - Open Copilot panel
- `<C-.>` - Next suggestion
- `<C-,>` - Previous suggestion
- `<C-\>` - Dismiss suggestion
- `<C-CR>` - Accept suggestion (inserts newline after accepting)

### Mason
- `:Mason` - Open Mason UI
- `:MasonInstall <package>` - Install LSP/DAP/Linter/Formatter
- `:MasonUninstall <package>` - Uninstall package
- `:MasonUpdate` - Update all packages

### Null-ls
- `<leader>f` - Format document (via Prettier)
- `<leader>e` - Show diagnostics (via ESLint)
- `<leader>ca` - Code actions (via ESLint)

### SQL/PostgreSQL
- `<leader>sf` - Format SQL file
- `<leader>se` - Explain selected query
- `<leader>sr` - Run selected query
- `<leader>st` - Show table structure
- `<leader>sd` - Show database sizes
- `<leader>ss` - Show table sizes
- `<leader>si` - Show index usage
- `<leader>sl` - Show long-running queries
- `<leader>sk` - Show locks
- `<leader>sv` - Show vacuum status

#### PostgreSQL Query Templates
- `<leader>qt` - Insert query template (interactive selection)
- `<leader>ql` - Show long-running queries template
- `<leader>qk` - Show locks template
- `<leader>qs` - Show table stats template
- `<leader>qi` - Show index stats template

#### PostgreSQL Connection Management
- `<leader>qc` - Switch database connection (interactive selection)

#### PostgreSQL Query Results
- `<leader>qf` - Format query results

#### PostgreSQL Query Templates Available
1. `explain` - EXPLAIN ANALYZE template
2. `create_table` - CREATE TABLE template with common fields
3. `create_index` - CREATE INDEX template
4. `vacuum_analyze` - VACUUM ANALYZE template
5. `table_stats` - Table statistics query
6. `index_stats` - Index statistics query
7. `long_running` - Long-running queries query
8. `locks` - Lock information query

#### PostgreSQL Connection Configuration
The configuration supports multiple database connections:
- Development (dev)
- Test (test)
- Production (prod)

Each connection can be configured with:
- Host
- Port
- Database name
- Username
- Password (via .pgpass)

### Bracket Operations
#### Surround Operations
- `<leader>b(` - Surround with parentheses
- `<leader>b[` - Surround with square brackets
- `<leader>b{` - Surround with curly braces
- `<leader>b<` - Surround with angle brackets
- `<leader>b'` - Surround with single quotes
- `<leader>b"` - Surround with double quotes
- `<leader>b`` - Surround with backticks

#### Delete Surrounding Brackets
- `<leader>bd(` - Delete surrounding parentheses
- `<leader>bd[` - Delete surrounding square brackets
- `<leader>bd{` - Delete surrounding curly braces
- `<leader>bd<` - Delete surrounding angle brackets
- `<leader>bd'` - Delete surrounding single quotes
- `<leader>bd"` - Delete surrounding double quotes
- `<leader>bd`` - Delete surrounding backticks

#### Change Surrounding Brackets
- `<leader>bc(` - Change to parentheses
- `<leader>bc[` - Change to square brackets
- `<leader>bc{` - Change to curly braces
- `<leader>bc<` - Change to angle brackets
- `<leader>bc'` - Change to single quotes
- `<leader>bc"` - Change to double quotes
- `<leader>bc`` - Change to backticks

#### Add Brackets at End of Line
- `<leader>ba(` - Add parentheses at end
- `<leader>ba[` - Add square brackets at end
- `<leader>ba{` - Add curly braces at end
- `<leader>ba<` - Add angle brackets at end
- `<leader>ba'` - Add single quotes at end
- `<leader>ba"` - Add double quotes at end
- `<leader>ba`` - Add backticks at end

#### Add Brackets at Start of Line
- `<leader>bi(` - Add parentheses at start
- `<leader>bi[` - Add square brackets at start
- `<leader>bi{` - Add curly braces at start
- `<leader>bi<` - Add angle brackets at start
- `<leader>bi'` - Add single quotes at start
- `<leader>bi"` - Add double quotes at start
- `<leader>bi`` - Add backticks at start

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

### Angular
- `<leader>saf` - Find Angular Component
- `<leader>sag` - Search in Angular App
- `<leader>gac` - Generate Angular Component
- `<leader>gas` - Generate Angular Service
- `<leader>gam` - Generate Angular Module

## Editor Settings

### Folding Strategy
- Uses LSP-based folding with Treesitter fallback for all languages
- Folding is based on semantic code structure rather than indentation
- All folds are open by default (foldlevel = 99)
- Fold column width is set to 4 characters
- Minimum 1 line required for a fold
- Maximum fold nesting level is 20

### Language-Specific Settings

#### Python
- Tab size: 4
- Expand tabs: Yes
- Text width: 88 (Black formatter default)
- Folding: LSP/Treesitter-based

#### JavaScript/TypeScript
- Tab size: 2
- Expand tabs: Yes
- Folding: LSP/Treesitter-based

#### HTML/CSS
- Tab size: 2
- Expand tabs: Yes
- Folding: LSP/Treesitter-based

#### Go
- Tab size: 4
- Expand tabs: No
- Folding: LSP/Treesitter-based

#### C/C++
- Tab size: 4
- Expand tabs: Yes
- Folding: LSP/Treesitter-based

#### Rust
- Tab size: 4
- Expand tabs: Yes
- Color column: 100
- Text width: 100
- Format options: cqrnj
- Folding: LSP-based

#### LaTeX
- Text width: 80
- Word wrap enabled
- Folding: LSP/Treesitter-based

#### Shell Scripts
- Folding: LSP/Treesitter-based

#### JSON/YAML/TOML
- Folding: LSP/Treesitter-based

#### Markdown and Text Files
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