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
--opt.cursorline = true
--opt.cursorcolumn = true
opt.scrolloff = 8
opt.signcolumn = "yes"
opt.updatetime = 50

-- term and localization
opt.guifont = { "JetBrainsMono Nerd Font", ":h14" }
opt.termguicolors = true
vim.cmd([[highlight Normal guibg=NONE ctermbg=NONE]])
vim.cmd([[highlight NormalNC guibg=NONE ctermbg=NONE]])
vim.cmd([[highlight EndOfBuffer guibg=NONE ctermbg=NONE]])
opt.langmap =
"ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz"

-- backup swap save
opt.autowriteall = true
opt.swapfile = false
opt.backup = false
opt.undofile = true
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"

-- folding
opt.foldmethod = "expr"
opt.foldenable = true
opt.foldcolumn = "4"
opt.foldlevel = 99
opt.foldminlines = 1
opt.foldnestmax = 20

opt.viewoptions = "folds,cursor,curdir,slash,unix"

local ssh_utils = require("motleyfesst.utils")
if ssh_utils.IS_NOT_SSH() then
	opt.sessionoptions = "blank,buffers,curdir,folds,help,options,tabpages,terminal,winsize"
else
	-- SSH sessions - simplified settings for better performance
	-- Disable persistent folding and advanced sessionoptions
end
