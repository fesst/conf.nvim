--remove netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
-- Set leader key before anything else
require("motleyfesst.remap")
require("motleyfesst.set")
require("motleyfesst.utils")
vim.opt.runtimepath:append({ is_not_ssh and "/opt/homebrew/opt/fzf" or "/usr/bin/fzf" })

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
local lazy_config = require("lazy").setup("motleyfesst.lazy", {
    lockfile = is_not_ssh() and "lazy-lock.json" or "lazy-lock.ssh.json",
})
local lazyconf = require("lazy.core.config")
lazyconf.options.lockfile = vim.fn.stdpath("config") .. "/lazy-lock.ssh.json"

-- Set up highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("highlight_yank", {}),
    desc = "Hightlight selection on yank",
    pattern = "*",
    callback = function()
        vim.highlight.on_yank({ higroup = "IncSearch", timeout = 40 })
    end,
})
