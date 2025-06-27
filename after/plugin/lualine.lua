require("motleyfesst/utils")

require("lualine").setup({
    options = {
        theme = is_not_ssh() and "rose-pine-alt" or "palenight", ---@usage 'rose-pine' | 'rose-pine-alt'
        refresh = {
            statusline = 100,
            tabline = 100,
            winbar = 100,
        },
    },
})
