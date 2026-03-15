local plugins_list = {
    { "nvim-tree/nvim-tree.lua", dependencies = { "nvim-tree/nvim-web-devicons" } },
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
    { "nanozuki/tabby.nvim", dependencies = { "nvim-tree/nvim-web-devicons" } },
    { "tpope/vim-fugitive" },
}
local ssh_utils = require("motleyfesst.ssh_utils")
if ssh_utils.IS_LOCAL() then
    local dev_list = {
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
                "b0o/schemastore.nvim",
            },
        },
        -- blink.cmp (old nvim-cmp config in after/discharged/completion/)
        {
            "saghen/blink.cmp",
            version = "*",
            lazy = false,
            dependencies = {
                { "saghen/blink.compat", version = "*", lazy = true },
                "alexander-born/cmp-bazel", -- nvim-cmp source, bridged via blink.compat
                "onsails/lspkind.nvim",
            },
        },
        { "mfussenegger/nvim-dap" },
        {
            "mfussenegger/nvim-jdtls",
            ft = "java",
        },
        {
            "stevearc/conform.nvim",
            event = { "BufWritePre" },
            cmd = { "ConformInfo" },
        },
        {
            "mfussenegger/nvim-lint",
            event = { "BufReadPre", "BufNewFile" },
        },
        { "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" } },
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
        {
            "meeehdi-dev/sunset.nvim",
            lazy = false,
            opts = { transparent = true, italic_comment = true },
            config = function()
                vim.cmd("colorscheme sunset")
            end,
        },
        {
            "rose-pine/neovim",
            name = "rose-pine",
            lazy = false,
            variant = "alt",
        },
    }
    for _, line in ipairs(ssh_list) do
        table.insert(plugins_list, line)
    end
end

table.insert(plugins_list, {
    "mcauley-penney/visual-whitespace.nvim",
    branch = "main",
    lazy = false,
})
return plugins_list
