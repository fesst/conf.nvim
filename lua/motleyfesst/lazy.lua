require("motleyfesst.utils")

local plugins_list = {
    { "nvim-tree/nvim-tree.lua",       dependencies = { "nvim-tree/nvim-web-devicons" } },
    { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "master",
        lazy = false,
        build = ":TSUpdate",
    },
    { "nvim-treesitter/playground" },
    { "mbbill/undotree" },
    { "theprimeagen/harpoon" },
    { "nvim-lualine/lualine.nvim", dependencies = { "nvim-tree/nvim-web-devicons" } },
    { "tpope/vim-fugitive" },
}
local utils = require("motleyfesst.utils")

if utils.IS_NOT_SSH() then
    local dev_list = {
        { "github/copilot.vim" },
        {
            "MeanderingProgrammer/render-markdown.nvim",
            dependencies = { "nvim-treesitter", "nvim-tree/nvim-web-devicons" },
        },
        {
            "williamboman/mason.nvim",
            dependencies = { "williamboman/mason-lspconfig.nvim", "neovim/nvim-lspconfig" },
            build = ":MasonUpdate",
            cmd = "Mason",
        },
        {
            "neovim/nvim-lspconfig",
            dependencies = {
                "williamboman/mason.nvim",
                "williamboman/mason-lspconfig.nvim",
                "hrsh7th/cmp-nvim-lsp",
                "b0o/schemastore.nvim",
            },
        },
        {
            "hrsh7th/nvim-cmp",
            dependencies = { "hrsh7th/cmp-buffer", "hrsh7th/cmp-path", "hrsh7th/cmp-nvim-lsp" },
        },
        { "mfussenegger/nvim-dap" },
        { "mfussenegger/nvim-jdtls" },
        {
            "nvimtools/none-ls.nvim",
            dependencies = { "nvim-lua/plenary.nvim" },
            event = { "BufReadPre", "BufNewFile" },
            config = function()
                local null_ls = require("null-ls")
                local builtins = null_ls.builtins

                if not builtins then
                    vim.notify("null-ls builtins not found", vim.log.levels.ERROR)
                    return
                end

                local sources = {}
                if builtins.formatting then
                    if builtins.formatting.stylua then
                        table.insert(sources, builtins.formatting.stylua)
                    end
                    if builtins.formatting.shfmt then
                        table.insert(sources, builtins.formatting.shfmt.with({ extra_args = { "-i", "2", "-ci" } }))
                    end
                end

                if builtins.diagnostics then
                    if builtins.diagnostics.shellcheck then
                        table.insert(
                            sources,
                            builtins.diagnostics.shellcheck.with({ filetypes = { "sh", "bash", "zsh" } })
                        )
                    else
                        vim.notify("shellcheck not found in null-ls builtins", vim.log.levels.WARN)
                    end
                    if builtins.diagnostics.luacheck then
                        table.insert(sources, builtins.diagnostics.luacheck)
                    end
                else
                    vim.notify("null-ls diagnostics not found", vim.log.levels.WARN)
                end
                null_ls.setup({ debug = false, sources = sources })
            end,
        },
        { "rcarriga/nvim-dap-ui",            dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" } },
        { "theHamsta/nvim-dap-virtual-text", dependencies = { "mfussenegger/nvim-dap" } },
        {
            "rose-pine/neovim",
            name = "rose-pine",
            lazy = false,
            priority = 1000,
            variant = "alt",
            config = function()
                require("rose-pine").setup({
                    alt_variant = "dawn",
                    disable_background = true,
                    disable_float_background = true,
                    disable_italics = false,
                    groups = {
                        background = "NONE",
                        background_nc = "NONE",
                        panel = "NONE",
                        panel_nc = "NONE",
                        border = "NONE",
                        comment = "NONE",
                    },
                })
                vim.cmd("colorscheme rose-pine")
            end,
        },
    }
    for _, line in ipairs(dev_list) do
        table.insert(plugins_list, line)
    end
else
    local ssh_list = {
        { "meeehdi-dev/sunset.nvim", opts = { transparent = true, italic_comment = true } },
        { "vague2k/vague.nvim" },
        -- {
            --     'wilmanbarrios/palenight.nvim',
            --     'alexmozaidze/palenight.nvim',
            -- },
        }
        for _, line in ipairs(ssh_list) do
            table.insert(plugins_list, line)
        end
    end
    return plugins_list
