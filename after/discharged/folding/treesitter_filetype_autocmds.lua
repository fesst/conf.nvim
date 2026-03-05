-- Old treesitter folding FileType autocmds (removed: now handled by global
-- foldexpr in set.lua + fold_utils.lua layered strategy)
-- To restore: add to after/plugin/treesitter.lua

local function setup_base_folding()
    vim.opt_local.foldmethod = "expr"
    vim.opt_local.foldenable = true
    vim.opt_local.foldcolumn = "4"
    vim.opt_local.foldlevel = 99
    vim.opt_local.foldminlines = 1
    vim.opt_local.foldnestmax = 20
end

vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile", "FileType" }, {
    pattern = { "*.lua", "lua" },
    callback = function()
        setup_base_folding()
        vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    end,
    group = vim.api.nvim_create_augroup("LuaFolding", { clear = true }),
})
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "c", "cpp", "objc", "cuda" },
    callback = function()
        setup_base_folding()
        vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    end,
    group = vim.api.nvim_create_augroup("CCPPFolding", { clear = true }),
})
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
    callback = function()
        setup_base_folding()
        vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    end,
    group = vim.api.nvim_create_augroup("JSTSFolding", { clear = true }),
})
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "json", "jsonc" },
    callback = function()
        setup_base_folding()
        vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    end,
    group = vim.api.nvim_create_augroup("JSONFolding", { clear = true }),
})
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "html", "htmldjango" },
    callback = function()
        setup_base_folding()
        vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    end,
    group = vim.api.nvim_create_augroup("HTMLFolding", { clear = true }),
})
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "css", "scss", "less" },
    callback = function()
        setup_base_folding()
        vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    end,
    group = vim.api.nvim_create_augroup("CSSFolding", { clear = true }),
})

-- Default fallback: treesitter folding for all filetypes not handled above
-- (was gated by IS_LOCAL())
local ssh_utils = require("motleyfesst.ssh_utils")
if ssh_utils.IS_LOCAL() then
    vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile", "FileType" }, {
        pattern = { "*" },
        callback = function()
            local skip_filetypes = {
                python = true,
                lua = true,
                sh = true,
                bash = true,
                zsh = true,
                c = true,
                cpp = true,
                objc = true,
                cuda = true,
                javascript = true,
                typescript = true,
                javascriptreact = true,
                typescriptreact = true,
                json = true,
                jsonc = true,
                html = true,
                htmldjango = true,
                css = true,
                scss = true,
                less = true,
            }
            if skip_filetypes[vim.bo.filetype] then
                return
            end
            setup_base_folding()
            vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
        end,
        group = vim.api.nvim_create_augroup("DefaultFolding", { clear = true }),
    })
end
