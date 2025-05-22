--remove netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
-- Set leader key before anything else
require("motleyfesst.remap")
require("motleyfesst.set")

vim.opt.runtimepath:append({ "/opt/homebrew/opt/fzf" })

-- Install Lazy.nvim if not already installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Configure Lazy.nvim and load plugins
require("lazy").setup("motleyfesst.lazy")

-- Set up highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("highlight_yank", {}),
    desc = "Hightlight selection on yank",
    pattern = "*",
    callback = function()
        vim.highlight.on_yank({ higroup = "IncSearch", timeout = 40 })
    end,
})
