local pt = require('motleyfesst.print_table')

local plugins_list =
{
    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("telescope").setup()
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
if is_not_ssh() then
    local dev_list = {
        {
            "MeanderingProgrammer/render-markdown.nvim",
            dependencies = { "nvim-treesitter", "nvim-tree/nvim-web-devicons" },
        },
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
                        table.insert(
                            sources,
                            builtins.formatting.shfmt.with({
                                extra_args = { "-i", "2", "-ci" },
                            })
                        )
                    end
                end

                -- Add diagnostics
                if builtins.diagnostics then
                    local shellcheck = builtins.diagnostics.shellcheck
                    if shellcheck then
                        table.insert(
                            sources,
                            shellcheck.with({
                                filetypes = { "sh", "bash", "zsh" },
                            })
                        )
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
            "rose-pine/neovim",
            name = "rose-pine",
            lazy = false,
            priority = 1000,
            variant = "alt",
            config = function()
                vim.g.rose_pine_variant = "alt"
                require("rose-pine").setup({
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
    for i, line in ipairs(dev_list) do
        table.insert(plugins_list, line)
    end
else
    local ssh_list = {
        {
            'meeehdi-dev/sunset.nvim',
            opts = {
                transparent = true,
                italic_comment = true,
            },
        },
        {
            "vague2k/vague.nvim",
            config = function()
                -- NOTE: you do not need to call setup if you don't want to.
                require("vague").setup({
                    transparent = true, -- don't set background
                    -- disable bold/italic globally in `style`
                    bold = true,
                    italic = true,
                    -- plugin styles where applicable
                    -- make an issue/pr if you'd like to see more styling options!
                    plugins = {
                        cmp = {
                            match = "bold",
                            match_fuzzy = "bold",
                        },
                        dashboard = {
                            footer = "italic",
                        },
                        lsp = {
                            diagnostic_error = "bold",
                            diagnostic_hint = "none",
                            diagnostic_info = "italic",
                            diagnostic_ok = "none",
                            diagnostic_warn = "bold",
                        },
                        neotest = {
                            focused = "bold",
                            adapter_name = "bold",
                        },
                        telescope = {
                            match = "bold",
                        },
                    },

                    -- Override highlights or add new highlights
                    on_highlights = function(highlights, colors) end,

                    -- Override colors
                    colors = {
                        bg = "#141415",
                        fg = "#cdcdcd",
                        floatBorder = "#878787",
                        line = "#252530",
                        comment = "#000000",
                        builtin = "#b4d4cf",
                        func = "#c48282",
                        string = "#e8b589",
                        number = "#e0a363",
                        property = "#c3c3d5",
                        constant = "#aeaed1",
                        parameter = "#bb9dbd",
                        visual = "#333738",
                        error = "#d8647e",
                        warning = "#f3be7c",
                        hint = "#7e98e8",
                        operator = "#90a0b5",
                        keyword = "#6e94b2",
                        type = "#9bb4bc",
                        search = "#405065",
                        plus = "#7fa563",
                        delta = "#f3be7c",
                    },
                })
            end
        }, 
        {
            'wilmanbarrios/palenight.nvim',
        },
    }
    for i, line in ipairs(ssh_list) do
        table.insert(plugins_list, line)
    end
end
return plugins_list

