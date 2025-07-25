local ssh_utils = require("motleyfesst.utils")

local function setup_base_folding()
    vim.opt_local.foldmethod = "expr"
    vim.opt_local.foldenable = true
    vim.opt_local.foldcolumn = "4"
    vim.opt_local.foldlevel = 99
    vim.opt_local.foldminlines = 1
    vim.opt_local.foldnestmax = 20
end

vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile", "FileType" }, {
    pattern = { "*.py", "python" },
    callback = function()
        setup_base_folding()
        vim.opt_local.foldmethod = "indent"
        vim.opt_local.foldexpr = "" -- Clear any expr-based folding
    end,
    group = vim.api.nvim_create_augroup("PythonFolding", { clear = true }),
})
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile", "FileType" }, {
    pattern = { "*.lua", "lua" },
    callback = function()
        setup_base_folding()
        vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    end,
    group = vim.api.nvim_create_augroup("LuaFolding", { clear = true }),
})
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile", "FileType" }, {
    pattern = { "*.sh", "*.bash", "*.zsh", "sh", "bash", "zsh" },
    callback = function()
        setup_base_folding()
        vim.opt_local.foldmethod = "indent"
        vim.opt_local.foldexpr = "" -- Clear any expr-based folding
    end,
    group = vim.api.nvim_create_augroup("ShellFolding", { clear = true }),
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
if ssh_utils.IS_NOT_SSH() then
    vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile", "FileType" }, {
        pattern = { "*" },
        callback = function()
            local skip_filetypes = { python = true, lua = true, sh = true, bash = true, zsh = true, c = true, cpp = true, objc = true, cuda = true, javascript = true, typescript = true, javascriptreact = true, typescriptreact = true, json = true, jsonc = true, html = true, htmldjango = true, css = true, scss = true, less = true, }
            if skip_filetypes[vim.bo.filetype] then
                return
            end
            setup_base_folding()
            vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
        end,
        group = vim.api.nvim_create_augroup("DefaultFolding", { clear = true }),
    })

    require("nvim-treesitter.configs").setup({
        ensure_installed = { "bash", "c", "cpp", "css", "csv", "diff", "dockerfile", "html", "jq", "json", "lua", "luadoc", "passwd", "python", "regex", "rust", "scss", "toml", "vim", "vimdoc", "xml", "yaml", },
        sync_install = false,
        auto_install = true,
        modules = {},
        ignore_install = {},
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
            disable = {},-- Add safety checks to prevent index out of bounds errors
        },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = "gnn",
                node_incremental = "grn",
                scope_incremental = "grc",
                node_decremental = "grm",
            },
        },
        indent = {
            enable = true,
        },
        textobjects = {
            select = {
                enable = true,
                lookahead = true,
                keymaps = {
                    ["af"] = "@function.outer",
                    ["if"] = "@function.inner",
                    ["ac"] = "@class.outer",
                    ["ic"] = "@class.inner",
                },
            },
        },
        fold = {
            enable = true,
        },
    })
end
