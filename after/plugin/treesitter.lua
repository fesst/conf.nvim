local ssh_utils = require("motleyfesst.utils.ssh")
local fold_utils = require("motleyfesst.utils.fold")

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
    })

    require("nvim-treesitter-textobjects").setup({
        select = {
            lookahead = true,
        },
    })

    local select = require("nvim-treesitter-textobjects.select")
    vim.keymap.set({ "x", "o" }, "af", function()
        select.select_textobject("@function.outer", "textobjects")
    end, { desc = "Tree-sitter around function" })
    vim.keymap.set({ "x", "o" }, "if", function()
        select.select_textobject("@function.inner", "textobjects")
    end, { desc = "Tree-sitter inner function" })
    vim.keymap.set({ "x", "o" }, "ac", function()
        select.select_textobject("@class.outer", "textobjects")
    end, { desc = "Tree-sitter around class" })
    vim.keymap.set({ "x", "o" }, "ic", function()
        select.select_textobject("@class.inner", "textobjects")
    end, { desc = "Tree-sitter inner class" })
end
