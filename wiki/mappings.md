# Key Mappings

## Overridden Default Mappings

The following default Neovim mappings have been overridden to provide more sophisticated functionality while maintaining similar usage patterns:

### Navigation

- `gd` - Overrides default "go to declaration" to use LSP's "go to definition"
- `K` - Overrides default "keyword lookup" to show LSP hover documentation
- `[i`/`]i` - Overrides default "previous/next indent" to navigate diagnostics

### Text Objects

- `af`/`if` - Overrides default "around/inner function" to use Tree-sitter for more accurate function selection
- `ac`/`ic` - Overrides default "around/inner class" to use Tree-sitter for more accurate class selection

### Tree-sitter

- `gnn` - Overrides default "next match" to start Tree-sitter selection
- `grn` - Overrides default "replace next match" to expand Tree-sitter selection
- `grc` - Overrides default "replace current match" to expand Tree-sitter scope
- `grm` - Overrides default "replace match" to shrink Tree-sitter selection

### Copilot

- `<C-.>`/`<C-,>` - Overrides default "next/previous quickfix" to navigate Copilot suggestions
- `<C-\>` - Overrides default "toggle terminal" to dismiss Copilot suggestion
- `<C-CR>` - Overrides default "new line" to accept Copilot suggestion

Note: These overrides are chosen to provide more sophisticated functionality while maintaining similar usage patterns. The original functionality can still be accessed through alternative mappings if needed.

## Core Navigation

- `<leader>pv` - Open file explorer
- `<leader>p-` - Toggle file explorer
- `<leader>tf` - Find files
- `<leader>te` - Recent files
- `<leader>ts` - Search text
- `<leader>tg` - Git files
- `<leader>tl` - Live grep
- `<leader>th` - Help tags

## Language Server Protocol (LSP)

- `gd` - Go to definition
- `K` - Hover docs
- `<leader>ca` - Code actions
- `<leader>rn` - Rename
- `<leader>f` - Format
- `<leader>e` - Show diagnostics
- `[i`/`]i` - Prev/Next diagnostic

## Debugging (DAP)

- `<leader>dc` - Start/Continue debug
- `<leader>di`/`do`/`du` - Step into/over/out
- `<leader>db` - Toggle breakpoint
- `<leader>dB` - Conditional breakpoint
- `<leader>dl` - Log point
- `<leader>dr` - Debug REPL
- `<leader>dL` - Run last debug configuration

## Git & Version Control

- `<leader>gs` - Git status
- `<leader>a` - Add to harpoon
- `<C-e>` - Harpoon menu
- `<leader>g1` to `<leader>g9` - Quick files

## Code Manipulation

- `<leader>u` - Undo tree
- `<leader>cp` - Copilot panel
- `<C-.>`/`<C-,>` - Next/Prev suggestion
- `<C-\>` - Dismiss suggestion
- `<C-CR>` - Accept suggestion

## Brackets Commands

**Умная логика удаления:**

- Если курсор находится **на левой скобке или правее** → поиск **вправо**
- Если курсор находится **на правой скобке или левее** → поиск **влево**

### Surround

**Visual mode** - окружить выделенное:

- `<leader>b(` - окружить круглыми скобками `()`
- `<leader>b[` - окружить квадратными скобками `[]`
- `<leader>b{` - окружить фигурными скобками `{}`
- `<leader>b<` - окружить угловыми скобками `<>`
- `<leader>b'` - окружить одинарными кавычками `''`
- `<leader>b"` - окружить двойными кавычками `""`
- `<leader>b`` ` - окружить обратными кавычками `` `` ``

**Normal mode** - умное определение и окружение объекта под курсором:

- `<leader>b(` - найти логический объект (${var}, "string", path, etc.) и окружить `()`
- `<leader>b[` - найти логический объект и окружить `[]`
- `<leader>b{` - найти логический объект и окружить `{}`
- `<leader>b<` - найти логический объект и окружить `<>`
- `<leader>b'` - найти логический объект и окружить `''`
- `<leader>b"` - найти логический объект и окружить `""`
- `<leader>b`` ` - найти логический объект и окружить `` `` ``

Поддерживаемые паттерны: `${переменные}`, `"строки"`, `'строки'`, `(скобки)`, `[скобки]`, `{скобки}`, `<скобки>`, `` `команды` ``, пути файлов.

### Delete (умная логика)

- `<leader>B(` - удалить круглые скобки `()`
- `<leader>B[` - удалить квадратные скобки `[]`
- `<leader>B{` - удалить фигурные скобки `{}`
- `<leader>B<` - удалить угловые скобки `<>`
- `<leader>B'` - удалить одинарные кавычки `''`
- `<leader>B"` - удалить двойные кавычки `""`
- `<leader>B`` ` - удалить обратные кавычки `` `` ``

### Change (умная логика)

- `<leader>bc(` - изменить на круглые скобки `()`
- `<leader>bc[` - изменить на квадратные скобки `[]`
- `<leader>bc{` - изменить на фигурные скобки `{}`
- `<leader>bc<` - изменить на угловые скобки `<>`
- `<leader>bc'` - изменить на одинарные кавычки `''`
- `<leader>bc"` - изменить на двойные кавычки `""`
- `<leader>bc`` ` - изменить на обратные кавычки `` `` ``

### Add

- `<leader>ba(` - добавить `()` в конец строки
- `<leader>bi(` - добавить `()` в начало строки

## Tree-sitter Features

### Navigation

- `gnn` - Start selection
- `grn` - Expand to next syntax node
- `grc` - Expand to next scope
- `grm` - Shrink to previous node

### Text Objects

- `af`/`if` - Select outer/inner function
- `ac`/`ic` - Select outer/inner class

## SQL/PostgreSQL Features

### Query Operations

- `<leader>sf` - Format SQL
- `<leader>se` - Explain query
- `<leader>sr` - Run query
- `<leader>st` - Table structure
- `<leader>sd` - DB sizes
- `<leader>ss` - Table sizes
- `<leader>si` - Index usage
- `<leader>sl` - Long queries
- `<leader>sk` - Locks
- `<leader>sv` - Vacuum status

### Query Templates

- `<leader>qt` - Insert query template
- `<leader>ql` - Long-running queries template
- `<leader>qk` - Locks template
- `<leader>qs` - Table stats template
- `<leader>qi` - Index stats template

### Connection Management

- `<leader>qc` - Switch database connection
- `<leader>qf` - Format query results

## Language-Specific Features

### Run & Test

- `<leader>yr` - Run file/project
- `<leader>yt` - Run tests

### Build & View

- `<leader>yb` - Build (LaTeX)
- `<leader>yv` - View (LaTeX PDF)
- `<leader>yd` - Docker build
- `<leader>yr` - Docker run

### Angular

- `<leader>saf` - Find Angular Component
- `<leader>sag` - Search in Angular App
- `<leader>gac` - Generate Angular Component
- `<leader>gas` - Generate Angular Service
- `<leader>gam` - Generate Angular Module

## Editor Settings

### Folding

- LSP/Treesitter-based folding
- All folds open by default (foldlevel = 99)
- Fold column width: 4 characters
- Minimum 1 line per fold
- Maximum nesting level: 20
- **Persistent folding state** - automatically saves and restores fold state between sessions
- `<leader>vs` - Save view (folding state) manually
- `<leader>vl` - Load view (folding state) manually
- `<leader>vr` - Force reload view (folding state)

### Language-Specific Settings

#### Python

- Tab size: 4
- Expand tabs: Yes
- Text width: 88 (Black formatter default)

#### JavaScript/TypeScript

- Tab size: 2
- Expand tabs: Yes

#### HTML/CSS

- Tab size: 2
- Expand tabs: Yes

#### Go

- Tab size: 4
- Expand tabs: No

#### C/C++

- Tab size: 4
- Expand tabs: Yes

#### Rust

- Tab size: 4
- Expand tabs: Yes
- Color column: 100
- Text width: 100
- Format options: cqrnj

#### LaTeX

- Text width: 80
- Word wrap enabled

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
- LaTeX
