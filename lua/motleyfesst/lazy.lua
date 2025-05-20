require("motleyfesst.remap")
return {
    -- Plugin specifications
    {
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
        cmd = "Mason",
        dependencies = {
            "williamboman/mason-lspconfig.nvim",
            "neovim/nvim-lspconfig",
        },
        config = function()
            require("mason").setup()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "gradle_ls",
                },
                handlers = {
                    function(server_name)
                        local lspconfig = require("lspconfig")
                        if server_name == "gradle_ls" then
                            lspconfig.gradle_ls.setup({
                                init_options = {
                                    settings = {
                                        gradle = {
                                            wrapperEnabled = true,
                                            wrapperPath = "gradle/wrapper/gradle-wrapper.jar",
                                        },
                                    },
                                },
                                settings = {
                                    gradle = {
                                        wrapperEnabled = true,
                                        wrapperPath = "gradle/wrapper/gradle-wrapper.jar",
                                    },
                                },
                                filetypes = { "groovy", "java", "kotlin" },
                                root_dir = lspconfig.util.root_pattern(
                                    "build.gradle",
                                    "build.gradle.kts",
                                    "settings.gradle",
                                    "settings.gradle.kts"
                                ),
                            })
                        else
                            lspconfig[server_name].setup({})
                        end
                    end,
                },
            })
        end,
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
        dependencies = {
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-nvim-lsp",
        },
    },
    {
        "mfussenegger/nvim-dap",
    },
    {
        "mfussenegger/nvim-jdtls",
    },
    {
        "jose-elias-alvarez/null-ls.nvim",
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
        dependencies = {
            "mfussenegger/nvim-dap",
            "nvim-neotest/nvim-nio",
        },
    },
    {
        "theHamsta/nvim-dap-virtual-text",
        dependencies = { "mfussenegger/nvim-dap" },
    },
    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
    },
    {
        "rose-pine/neovim",
        name = "rose-pine",
        config = function()
            vim.cmd("colorscheme rose-pine")
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
    },
    {
        "nvim-treesitter/playground",
    },
    {
        "mbbill/undotree",
    },
    {
        "theprimeagen/harpoon",
    },
    {
        "github/copilot.vim",
        event = "InsertEnter",
        config = function()
            vim.g.copilot_no_tab_map = true
            vim.g.copilot_assume_mapped = true
            vim.g.copilot_tab_fallback = ""
        end,
    },
    {
        "nvim-tree/nvim-tree.lua",
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
        dependencies = { "nvim-treesitter", "nvim-tree/nvim-web-devicons" },
        config = function()
            require("render-markdown").setup({})
        end,
    },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },
    {
        "tpope/vim-fugitive",
    },
}
