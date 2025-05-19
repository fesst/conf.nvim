require("motleyfesst.remap")
return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/cmp-nvim-lsp",
            "b0o/schemastore.nvim"
        }
    },
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-nvim-lsp"
        }
    },
    "mfussenegger/nvim-dap",
    "mfussenegger/nvim-jdtls",
    "jose-elias-alvarez/null-ls.nvim",
    {
        "rcarriga/nvim-dap-ui",
        dependencies = { 
            "mfussenegger/nvim-dap",
            "nvim-neotest/nvim-nio"
        }
    },
    {
        "theHamsta/nvim-dap-virtual-text",
        dependencies = { "mfussenegger/nvim-dap" }
    },
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.8",
        dependencies = { "nvim-lua/plenary.nvim" }
    },
    {
        "rose-pine/neovim",
        name = "rose-pine",
        config = function()
            vim.cmd("colorscheme rose-pine")
        end
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate"
    },
    "nvim-treesitter/playground",
    "mbbill/undotree",
    "theprimeagen/harpoon",
    "github/copilot.vim",
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" }
    },
    {
        "MeanderingProgrammer/render-markdown.nvim",
        dependencies = { "nvim-treesitter", "nvim-tree/nvim-web-devicons" },
        config = function()
            require("render-markdown").setup({})
        end
    },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" }
    },
    {
        "tpope/vim-fugitive"
    }
}
