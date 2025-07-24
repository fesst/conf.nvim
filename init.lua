vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("motleyfesst.remap") -- set leader key before anything else and load utils
require("motleyfesst.set")

vim.opt.runtimepath:append({ IS_NOT_SSH() and "/opt/homebrew/opt/fzf" or "/usr/bin/fzf" })

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath, })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup("motleyfesst.lazy", {
    lockfile = vim.fn.stdpath("config") .. (IS_NOT_SSH() and "/lazy-lock.json" or "/lazy-lock.ssh.json"),
})

-- Set up highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("highlight_yank", {}),
    desc = "Hightlight selection on yank",
    pattern = "*",
    callback = function()
        vim.highlight.on_yank({ higroup = "IncSearch", timeout = 40 })
    end,
})
