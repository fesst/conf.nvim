-- Remove the require("motleyfesst.remap") line as it's already in init.lua
return {
    -- Plugin specifications
    {
        "williamboman/mason.nvim",
        version = "v2.0.0",
        build = ":MasonUpdate",
        cmd = "Mason",
        dependencies = {
            "williamboman/mason-lspconfig.nvim",
            "neovim/nvim-lspconfig",
        },
        config = function()
            require("mason").setup()
            require("mason-lspconfig").setup()
        end,
    },
    {
        "neovim/nvim-lspconfig",
        version = "v0.1.8",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/cmp-nvim-lsp",
            "b0o/schemastore.nvim"
        }
    },
    {
        "hrsh7th/nvim-cmp",
        version = "v0.1.0",
        dependencies = {
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-nvim-lsp"
        }
    },
    {
        "mfussenegger/nvim-dap",
        version = "v0.6.0"
    },
    {
        "mfussenegger/nvim-jdtls",
        version = "v0.1.0"
    },
    {
        "jose-elias-alvarez/null-ls.nvim",
        version = "v3.0.0",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local null_ls = require("null-ls")
            null_ls.setup({
                sources = {
                    null_ls.builtins.formatting.prettier,
                    null_ls.builtins.diagnostics.eslint,
                    null_ls.builtins.code_actions.eslint,
                },
            })
        end,
    },
    {
        "rcarriga/nvim-dap-ui",
        version = "v3.9.1",
        dependencies = { 
            "mfussenegger/nvim-dap",
            "nvim-neotest/nvim-nio"
        }
    },
    {
        "theHamsta/nvim-dap-virtual-text",
        version = "v1.4.4",
        dependencies = { "mfussenegger/nvim-dap" }
    },
    {
        "nvim-telescope/telescope.nvim",
        version = "0.1.8",
        dependencies = { "nvim-lua/plenary.nvim" }
    },
    {
        "rose-pine/neovim",
        version = "v1.0.0",
        name = "rose-pine",
        config = function()
            vim.cmd("colorscheme rose-pine")
        end
    },
    {
        "nvim-treesitter/nvim-treesitter",
        version = "v0.9.2",
        build = ":TSUpdate"
    },
    {
        "nvim-treesitter/playground",
        version = "v0.0.1"
    },
    {
        "mbbill/undotree",
        version = "v6.1"
    },
    {
        "theprimeagen/harpoon",
        version = "v2.0.0"
    },
    {
        "github/copilot.vim",
        version = "v1.0.0"
    },
    {
        "nvim-tree/nvim-tree.lua",
        version = "v1.0.0",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("nvim-tree").setup({
                view = {
                    width = 30,
                },
                renderer = {
                    group_empty = true,
                },
                filters = {
                    dotfiles = false,
                },
            })
        end,
    },
    {
        "MeanderingProgrammer/render-markdown.nvim",
        version = "v0.1.0",
        dependencies = { "nvim-treesitter", "nvim-tree/nvim-web-devicons" },
        config = function()
            require("render-markdown").setup({})
        end
    },
    {
        "nvim-lualine/lualine.nvim",
        version = "v0.10.0",
        dependencies = { "nvim-tree/nvim-web-devicons" }
    },
    {
        "tpope/vim-fugitive",
        version = "v3.7"
    }
}
