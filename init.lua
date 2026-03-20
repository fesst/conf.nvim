vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("motleyfesst.remap") -- set leader key before anything else and load utils
require("motleyfesst.set")

local ssh_utils = require("motleyfesst.utils.ssh")
vim.opt.runtimepath:append({ ssh_utils.IS_MAC() and "/opt/homebrew/opt/fzf" or "/usr/bin/fzf" })

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable",
        lazypath, })
end

vim.opt.rtp:prepend(lazypath)
require("lazy").setup("motleyfesst.lazy", {
    lockfile = vim.fn.stdpath("config") .. (ssh_utils.IS_LOCAL() and "/lazy-lock.json" or "/lazy-lock.ssh.json"),
})
