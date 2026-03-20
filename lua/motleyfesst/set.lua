local opt = vim.opt

local function setup_yank_behavior()
    vim.api.nvim_create_autocmd("TextYankPost", {
        group = vim.api.nvim_create_augroup("YankBehavior", { clear = true }),
        desc = "Mirror yanks to clipboard and highlight them",
        callback = function()
            local event = vim.v.event
            if not event or event.operator ~= "y" then
                return
            end

            if event.regcontents and #event.regcontents > 0 then
                pcall(vim.fn.setreg, "+", event.regcontents, event.regtype)
                pcall(vim.fn.setreg, "*", event.regcontents, event.regtype)
            end

            vim.highlight.on_yank({ higroup = "IncSearch", timeout = 40 })
        end,
    })
end

opt.hidden = true
opt.number = true
opt.relativenumber = true
opt.wrap = true

-- clipboard: nvim uses its own registers, system clipboard via Ctrl+Shift+V (kitty)
opt.clipboard = ""

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
local undodir = vim.fn.expand("$HOME/.vim/undodir")
opt.undodir = undodir
vim.fn.mkdir(undodir, "p")

-- folding
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldenable = true
opt.foldcolumn = "4"
opt.foldlevel = 99
opt.foldminlines = 1
opt.foldnestmax = 20

opt.viewoptions = "folds,cursor,curdir,slash,unix"

opt.sessionoptions = "blank,buffers,curdir,folds,help,options,tabpages,terminal,winsize"

setup_yank_behavior()
