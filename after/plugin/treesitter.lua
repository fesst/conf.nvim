local ssh_utils = require("motleyfesst.ssh_utils")
local fold_utils = require("motleyfesst.fold_utils")

-- Indent-based folding for filetypes where treesitter folding is poor.
-- Global default (set.lua) provides treesitter folding for everything else.
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "python" },
    callback = function()
        fold_utils.setup_indent()
    end,
    group = vim.api.nvim_create_augroup("PythonFolding", { clear = true }),
})
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "sh", "bash", "zsh" },
    callback = function()
        fold_utils.setup_indent()
    end,
    group = vim.api.nvim_create_augroup("ShellFolding", { clear = true }),
})

if ssh_utils.IS_LOCAL() then
    require("nvim-treesitter.configs").setup({
        ensure_installed = {
            "bash",
            "c",
            "cpp",
            "css",
            "csv",
            "diff",
            "dockerfile",
            "graphql",
            "html",
            "jq",
            "java",
            "json",
            "lua",
            "luadoc",
            "passwd",
            "python",
            "regex",
            "rust",
            "scss",
            "toml",
            "vim",
            "vimdoc",
            "xml",
            "yaml",
            "starlark",
        },
        sync_install = false,
        auto_install = true,
        modules = {},
        ignore_install = {},
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
            disable = {}, -- Add safety checks to prevent index out of bounds errors
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
