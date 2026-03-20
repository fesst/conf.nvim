# Neovim Keymaps Reference

**Leader Key**: `<Space>`

Mappings are organized by mode and sorted alphabetically within each mode.

---

## Normal Mode (`n`)

### Completion
| Key | Action | File |
|---|---|---|
| `<leader><C-Space>` | Completion menu (blink.cmp) | `remap.lua` |
| `<leader><C-@>` | Completion menu (blink.cmp) | `remap.lua` |

### Debug (DAP)
| Key | Action | File |
|---|---|---|
| `<leader>dB` | Debug: Toggle breakpoint with condition/log | `dap.lua` |
| `<leader>dL` | Debug: Run Last | `dap.lua` |
| `<leader>db` | Debug: Toggle Breakpoint | `dap.lua` |
| `<leader>dc` | Debug: Start/Continue | `dap.lua` |
| `<leader>di` | Debug: Step Into | `dap.lua` |
| `<leader>dl` | Debug: Show DAP log | `dap.lua` |
| `<leader>do` | Debug: Step Over | `dap.lua` |
| `<leader>dr` | Debug: Open REPL | `dap.lua` |
| `<leader>du` | Debug: Step Out | `dap.lua` |

### File Operations
| Key | Action | File |
|---|---|---|
| `<leader>*` | Clear search highlights `:nohlsearch` | `remap.lua` |
| `<leader>R` | Reload current file `:source %` | `remap.lua` |
| `<leader>gF` | Open file (vertical split) `:vnew <cfile>` | `remap.lua` |
| `<leader>gf` | Open file (horizontal split) `:new <cfile>` | `remap.lua` |
| `<leader>m` | Show messages `:messages` | `remap.lua` |
| `<leader>q` | Write and quit `:wq` | `remap.lua` |
| `<leader>w` | Write file `:write %` | `remap.lua` |

### Git
| Key | Action | File |
|---|---|---|
| `<leader>gs` | Git status (vim-fugitive) | `fugitive.lua` |

### Harpoon Navigation
| Key | Action | File |
|---|---|---|
| `<leader>a` | Add file to harpoon | `harpoon.lua` |
| `<leader>g1` | Jump to harpoon file 1 | `harpoon.lua` |
| `<leader>g2` | Jump to harpoon file 2 | `harpoon.lua` |
| `<leader>g3` | Jump to harpoon file 3 | `harpoon.lua` |
| `<leader>g4` | Jump to harpoon file 4 | `harpoon.lua` |
| `<leader>g5` | Jump to harpoon file 5 | `harpoon.lua` |
| `<leader>g6` | Jump to harpoon file 6 | `harpoon.lua` |
| `<leader>g7` | Jump to harpoon file 7 | `harpoon.lua` |
| `<leader>g8` | Jump to harpoon file 8 | `harpoon.lua` |
| `<leader>g9` | Jump to harpoon file 9 | `harpoon.lua` |

### Java Actions (jdtls)
| Key | Action | File |
|---|---|---|
| `<leader>jf` | Java: Test class (File) | `remap.lua` |
| `<leader>jn` | Java: Test nearest method | `remap.lua` |

### LSP Core
| Key | Action | File |
|---|---|---|
| `<leader>ca` | Code action | `utils/lsp.lua` |
| `<leader>e` | Show diagnostic float | `utils/lsp.lua` |
| `<leader>f` | Format buffer | `utils/lsp.lua` |
| `<leader>rn` | Rename symbol | `utils/lsp.lua` |
| `[i` | Previous diagnostic | `utils/lsp.lua` |
| `]i` | Next diagnostic | `utils/lsp.lua` |
| `gd` | Go to definition | `utils/lsp.lua` |
| `K` | Hover | `utils/lsp.lua` |

### Brackets & Pairs
| Key | Action | File |
|---|---|---|
| `<leader>B(` | Delete surrounding `(` `)` | `remap.lua` |
| `<leader>B[` | Delete surrounding `[` `]` | `remap.lua` |
| `<leader>B{` | Delete surrounding `{` `}` | `remap.lua` |
| `<leader>B<` | Delete surrounding `<` `>` | `remap.lua` |
| `<leader>B'` | Delete surrounding `'` `'` | `remap.lua` |
| `<leader>B"` | Delete surrounding `"` `"` | `remap.lua` |
| `<leader>B\`` | Delete surrounding `` ` `` `` ` `` | `remap.lua` |
| `<leader>ba(` | Add `()` at end of line | `remap.lua` |
| `<leader>ba[` | Add `[]` at end of line | `remap.lua` |
| `<leader>ba{` | Add `{}` at end of line | `remap.lua` |
| `<leader>ba<` | Add `<>` at end of line | `remap.lua` |
| `<leader>bi(` | Add `()` at start of line | `remap.lua` |
| `<leader>bi[` | Add `[]` at start of line | `remap.lua` |
| `<leader>bi{` | Add `{}` at start of line | `remap.lua` |
| `<leader>bi<` | Add `<>` at start of line | `remap.lua` |
| `<leader>b(` | Wrap word/selection in `(` `)` | `remap.lua` |
| `<leader>b[` | Wrap word/selection in `[` `]` | `remap.lua` |
| `<leader>b{` | Wrap word/selection in `{` `}` | `remap.lua` |
| `<leader>b<` | Wrap word/selection in `<` `>` | `remap.lua` |
| `<leader>b'` | Wrap word/selection in `'` `'` | `remap.lua` |
| `<leader>b"` | Wrap word/selection in `"` `"` | `remap.lua` |
| `<leader>b\`` | Wrap word/selection in `` ` `` `` ` `` | `remap.lua` |

### Navigation Tree & View
| Key | Action | File |
|---|---|---|
| `<leader>pc` | Close nvim-tree | `nvim-tree.lua` |
| `<leader>pp` | Toggle nvim-tree | `nvim-tree.lua` |
| `<leader>pv` | Find current file in tree | `nvim-tree.lua` |

### Persistent Folding
| Key | Action | File |
|---|---|---|
| `<leader>vl` | Load view (folding state) | `persistent_folding.lua` |
| `<leader>vr` | Load view (force reload) | `persistent_folding.lua` |
| `<leader>vs` | Save view (folding state) | `persistent_folding.lua` |

### Tabs (tabby.nvim)
| Key | Action | File |
|---|---|---|
| `<leader><Tab>$` | Jump to last tab | `tabby.lua` |
| `<leader><Tab>1` | Jump to tab 1 | `tabby.lua` |
| `<leader><Tab>2` | Jump to tab 2 | `tabby.lua` |
| `<leader><Tab>3` | Jump to tab 3 | `tabby.lua` |
| `<leader><Tab>4` | Jump to tab 4 | `tabby.lua` |
| `<leader><Tab>5` | Jump to tab 5 | `tabby.lua` |
| `<leader><Tab>c` | Close tab | `tabby.lua` |
| `<leader><Tab>h` | Previous tab | `tabby.lua` |
| `<leader><Tab>j` | Jump to tab (single-key mode) | `tabby.lua` |
| `<leader><Tab>l` | Next tab | `tabby.lua` |
| `<leader><Tab>n` | New tab | `tabby.lua` |
| `<leader><Tab>r` | Rename current tab | `tabby.lua` |

### Telescope
| Key | Action | File |
|---|---|---|
| `<leader>ta` | Telescope: Autocommands | `telescope.lua` |
| `<leader>tb` | Telescope: Buffers | `telescope.lua` |
| `<leader>tc` | Telescope: Commands | `telescope.lua` |
| `<leader>te` | Telescope: Old files | `telescope.lua` |
| `<leader>tf` | Telescope: Find files | `telescope.lua` |
| `<leader>tgb` | Telescope: Buffer's commits | `telescope.lua` |
| `<leader>tgc` | Telescope: Git commits | `telescope.lua` |
| `<leader>tgf` | Telescope: Git files | `telescope.lua` |
| `<leader>tgs` | Telescope: Git status | `telescope.lua` |
| `<leader>th` | Telescope: Help tags | `telescope.lua` |
| `<leader>ti` | Telescope: Highlights | `telescope.lua` |
| `<leader>tj` | Telescope: Jumplist | `telescope.lua` |
| `<leader>tk` | Telescope: Keymaps | `telescope.lua` |
| `<leader>tl` | Telescope: Live grep | `telescope.lua` |
| `<leader>tm` | Telescope: Marks | `telescope.lua` |
| `<leader>tp` | Telescope: Man pages | `telescope.lua` |
| `<leader>tq` | Telescope: Quickfix history | `telescope.lua` |
| `<leader>tr` | Telescope: Registers | `telescope.lua` |
| `<leader>tt` | Telescope: Find files (smart) | `telescope.lua` |
| `<leader>tu` | Telescope: Resume last search | `telescope.lua` |
| `<leader>tv` | Telescope: Vim options | `telescope.lua` |
| `<leader>tyT` | Telescope LSP: Type definitions | `telescope.lua` |
| `<leader>tyd` | Telescope LSP: Document symbols | `telescope.lua` |
| `<leader>tyi` | Telescope LSP: Implementations | `telescope.lua` |
| `<leader>tyr` | Telescope LSP: References | `telescope.lua` |
| `<leader>tyt` | Telescope LSP: Definitions | `telescope.lua` |
| `<leader>tyw` | Telescope LSP: Workspace symbols | `telescope.lua` |

### Terminal
| Key | Action | File |
|---|---|---|
| `<leader>TT` | New bottom terminal (1/4 height) | `remap.lua` |
| `<leader>Ts` | New side (vertical) terminal | `remap.lua` |
| `<leader>Tt` | Toggle persistent bottom terminal | `remap.lua` |

### Undo Tree
| Key | Action | File |
|---|---|---|
| `<leader>u` | Toggle undo tree | `undotree.lua` |

### Misc
| Key | Action | File |
|---|---|---|
| `<C-e>` | Harpoon: Toggle quick menu | `harpoon.lua` |

---

## Visual Mode (`v`)

### Brackets & Pairs
| Key | Action | File |
|---|---|---|
| `<leader>b(` | Wrap selection in `(` `)` | `remap.lua` |
| `<leader>b[` | Wrap selection in `[` `]` | `remap.lua` |
| `<leader>b{` | Wrap selection in `{` `}` | `remap.lua` |
| `<leader>b<` | Wrap selection in `<` `>` | `remap.lua` |
| `<leader>b'` | Wrap selection in `'` `'` | `remap.lua` |
| `<leader>b"` | Wrap selection in `"` `"` | `remap.lua` |
| `<leader>b\`` | Wrap selection in `` ` `` `` ` `` | `remap.lua` |

### Clipboard
| Key | Action | File |
|---|---|---|
| `<leader>=` | Copy to system clipboard (`"+y`) | `remap.lua` |
| `<leader>8` | Copy to selection clipboard (`"*y`) | `remap.lua` |

### Code Refactor (jdtls)
| Key | Action | File |
|---|---|---|
| `crv` | Extract variable (visual) | `remap.lua` |
| `crc` | Extract constant (visual) | `remap.lua` |
| `crm` | Extract method (visual) | `remap.lua` |

### Completion
| Key | Action | File |
|---|---|---|
| `<leader><C-Space>` | Completion menu | `remap.lua` |
| `<leader><C-@>` | Completion menu | `remap.lua` |

### File Operations
| Key | Action | File |
|---|---|---|
| `<leader>gF` | Open file (vertical split) | `remap.lua` |
| `<leader>gf` | Open file (horizontal split) | `remap.lua` |

### Terminal
| Key | Action | File |
|---|---|---|
| `<leader>TT` | New bottom terminal (1/4 height) | `remap.lua` |
| `<leader>Ts` | New side (vertical) terminal | `remap.lua` |
| `<leader>Tt` | Toggle persistent bottom terminal | `remap.lua` |

### Undo Tree
| Key | Action | File |
|---|---|---|
| `<leader>U` | Close undo view | `undotree.lua` |

### Visual Whitespace
| Key | Action | File |
|---|---|---|
| `<leader>vv` | Toggle visual whitespace | `visual-whitespace.lua` |

---

## Insert Mode (`i`)

| Key | Action | File |
|---|---|---|
| `<A-u>` | Toggle undo tree | `undotree.lua` |

---

## Terminal Mode (`t`)

| Key | Action | File |
|---|---|---|
| `<A-q>` | Exit terminal insert mode (`<C-\><C-n>`) | `remap.lua` |

---

## Multi-Mode

### Normal & Visual (`n`, `v`)

| Key | Action | File |
|---|---|---|
| `<leader><C-Space>` | Completion menu | `remap.lua` |
| `<leader><C-@>` | Completion menu | `remap.lua` |
| `<leader>TT` | New bottom terminal | `remap.lua` |
| `<leader>Ts` | New side terminal | `remap.lua` |
| `<leader>Tt` | Toggle bottom terminal | `remap.lua` |
| `<leader>gF` | Open file (vertical split) | `remap.lua` |
| `<leader>gf` | Open file (horizontal split) | `remap.lua` |

### Normal & Visual (`n`, `v`) - Continued
| Key | Action | File |
|---|---|---|
| `<leader>vv` | Toggle visual whitespace | `visual-whitespace.lua` |

---

## Code Refactor (jdtls) - Normal Mode

| Key | Action | File |
|---|---|---|
| `crv` | Extract variable | `remap.lua` |
| `crc` | Extract constant | `remap.lua` |

---

# User-Defined Keymaps for Future Use

Add your custom keymaps here for organization:

```lua
-- Example template:
-- vim.keymap.set("n", "<leader>xx", function() ... end, { desc = "Description" })
```

---

## Notes

- All mappings use `noremap = true` and `silent = true` by default (set in `remap.lua`)
- `<leader>` is mapped to `<Space>`
- **Conflicts**: None detected between different plugins
- **Available prefixes** for future expansion:
  - `<leader>s*` (Settings)
  - `<leader>n*` (Neovim-specific)
  - `<leader>l*` (Logger)
  - `<leader>c*` (Custom)
  - `<leader>x*` (Execute/eXecute language commands)

## Legend

- DAP = Debug Adapter Protocol (dap.nvim)
- LSP = Language Server Protocol
- jdtls = Java Debug Language Server
