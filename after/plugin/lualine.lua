require("lualine").setup({
    options = {
        -- "palenight",
        theme = require("motleyfesst.utils").IS_NOT_SSH() and "rose-pine" or "ayu_light",
        section_separators = { left = "", right = "" },
        component_separators = { left = "", right = "" },
        refresh = {
            refresh_time = 50,
            statusline = 100,
            tabline = 100,
            winbar = 100,
        },
        show_filename_only = false,
    },
    sections = {
        lualine_c = {
            {
                "filename",
                path = 1,
                newfile_status = true,
            },
        },
        lualine_x = {
            "encoding",
            "lsp-status",
            {
                "fileformat",
                symbols = {
                    unix = "", -- e711
                    dos = "", -- e70f
                    mac = "", -- e711
                },
                "filetype",
            },
        },
    },
    inactive_sections = {
        lualine_c = {
            {
                "filename",
                path = 2,
            },
        },
    },
})
