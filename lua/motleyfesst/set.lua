vim.wo.number = true
vim.wo.relativenumber = true

local opt = vim.opt

opt.hidden = true
opt.number = true
opt.wrap = true

-- search
opt.hlsearch = false
opt.incsearch = true

-- tabs
opt.expandtab = true
opt.shiftwidth = 4
opt.smartindent = true
opt.tabstop = 4

-- windows 
opt.splitright = true
opt.splitbelow = true

-- editor appearance
opt.cursorline = true
opt.cursorcolumn = true
opt.scrolloff = 8
opt.signcolumn = "yes"
opt.updatetime = 50

-- term and localization
opt.guifont = { "JetBrainsMono Nerd Font", ":h12" }
opt.termguicolors = true
opt.langmap = "ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz"

-- backup swap save
opt.autowriteall = true
opt.swapfile = false
opt.backup = false
opt.undofile = true
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"

-- folding
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.lsp.foldexpr() or nvim_treesitter#foldexpr()"
opt.foldlevelstart = 99  -- Start with all folds open
opt.foldenable = true
opt.foldcolumn = "4"  -- Show fold column with width of 4
opt.foldminlines = 1  -- Minimum number of lines for a fold
opt.foldnestmax = 20  -- Maximum fold nesting level
