-- Disable netrw (former netrw configuration)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Nvim-tree configuration
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
    -- Additional settings from former netrw configuration
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
            window_picker = {
                enable = true,
            },
        },
    },
}) 