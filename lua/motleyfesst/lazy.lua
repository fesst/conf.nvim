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
            require("mason").setup({
                ui = {
                    icons = {
                        package_installed = "✓",
                        package_pending = "➜",
                        package_uninstalled = "✗",
                    },
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
        config = function()
            require("dap")
        end,
    },
    {
        "mfussenegger/nvim-jdtls",
    },
    {
        "nvimtools/none-ls.nvim",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local null_ls = require("null-ls")
            local builtins = null_ls.builtins

            -- Verify builtins are loaded
            if not builtins then
                vim.notify("null-ls builtins not found", vim.log.levels.ERROR)
                return
            end

            local sources = {}

            -- Add formatters
            if builtins.formatting then
                table.insert(sources, builtins.formatting.stylua)
                if builtins.formatting.shfmt then
                    table.insert(sources, builtins.formatting.shfmt.with({
                        extra_args = { "-i", "2", "-ci" },
                    }))
                end
            end

            -- Add diagnostics
            if builtins.diagnostics then
                local shellcheck = builtins.diagnostics.shellcheck
                if shellcheck then
                    table.insert(sources, shellcheck.with({
                        filetypes = { "sh", "bash", "zsh" }
                    }))
                else
                    vim.notify("shellcheck not found in null-ls builtins", vim.log.levels.WARN)
                end
            else
                vim.notify("null-ls diagnostics not found", vim.log.levels.WARN)
            end

            -- Configure null-ls
            null_ls.setup({
                debug = true,
                sources = sources,
            })
        end,
    },
    {
        "rcarriga/nvim-dap-ui",
        dependencies = {
            "mfussenegger/nvim-dap",
            "nvim-neotest/nvim-nio",
        },
        config = function()
            require("dapui").setup()
        end,
    },
    {
        "theHamsta/nvim-dap-virtual-text",
        dependencies = { "mfussenegger/nvim-dap" },
        config = function()
            require("nvim-dap-virtual-text").setup()
        end,
    },
    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("telescope").setup()
        end,
    },
    {
        "rose-pine/neovim",
        name = "rose-pine",
        lazy = false,
        priority = 1000,
        config = function()
            vim.g.rose_pine_variant = "alt"
            vim.cmd("colorscheme rose-pine")
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = { "lua", "vim", "vimdoc" },
                auto_install = true,
                highlight = { enable = true },
                fold = {
                    enable = true,
                    disable = {},
                },
            })
        end,
    },
    {
        "nvim-treesitter/playground",
    },
    {
        "mbbill/undotree",
        config = function()
            vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
        end,
    },
    {
        "theprimeagen/harpoon",
        config = function()
            local mark = require("harpoon.mark")
            local ui = require("harpoon.ui")

            vim.keymap.set("n", "<leader>a", mark.add_file)
            vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu)

            for i = 1, 9 do
                vim.keymap.set("n", "<leader>g" .. i, function()
                    ui.nav_file(i - 1)
                end)
            end
        end,
    },
    {
        "github/copilot.vim",
        lazy = false,
    },
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("nvim-tree").setup({
                sync_root_with_cwd = true,
                reload_on_bufenter = true,
                hijack_directories = {
                    enable = false,
                },
                sort = {
                    sorter = "case_sensitive",
                },
                view = {
                    width = 30,
                },
                renderer = {
                    group_empty = true,
                },
                filters = {
                    dotfiles = false,
                },
                git = {
                    enable = true,
                },
                update_focused_file = {
                    enable = true,
                    update_cwd = true,
                },
                diagnostics = {
                    enable = true,
                    icons = {
                        hint = "󰠠",
                        info = "󰋼",
                        warning = "󰅚",
                        error = "󰅚",
                    },
                },
                actions = {
                    open_file = {
                        quit_on_open = true,
                        window_picker = {
                            enable = true,
                        },
                    },
                },
            })

            vim.keymap.set("n", "<leader>pv", ":NvimTreeFindFile<CR>", { noremap = true, silent = true })
            vim.keymap.set("n", "<leader>p-", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
        end,
    },
    {
        "MeanderingProgrammer/render-markdown.nvim",
        dependencies = { "nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("lualine").setup()
        end,
    },
    {
        "tpope/vim-fugitive",
        config = function()
            vim.keymap.set("n", "<leader>gs", vim.cmd.Git)
        end,
    },
}
