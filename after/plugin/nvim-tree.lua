local HEIGHT_RATIO = 0.9
local WIDTH_RATIO = 0.75

require("nvim-tree").setup({
    hijack_cursor = true,
    disable_netrw = true,
    hijack_unnamed_buffer_when_opening = true,
    sync_root_with_cwd = true,
    reload_on_bufenter = true,
    system_open = vim.fn.has("mac") == 1 and { cmd = "open", args = { "-R" } } or nil,
    view = {
        centralize_selection = true,
        side = "right",
        preserve_window_proportions = true,
        relativenumber = true,
        float = {
            enable = true,
            open_win_config = function()
                local screen = vim.api.nvim_get_current_win()
                local cmdheight = vim.opt.cmdheight:get()

                local screen_h = vim.api.nvim_win_get_height(screen) - cmdheight
                local window_h = HEIGHT_RATIO * screen_h
                local window_h_int = math.floor(window_h)
                local center_y = ((screen_h - window_h) / 2) - cmdheight

                local screen_w = vim.api.nvim_win_get_width(screen) -- - vim.opt.numberwidth:get() - vim.opt.foldcolumn:get()
                local window_w = WIDTH_RATIO * screen_w
                local window_w_int = math.floor(window_w)
                local center_x = (screen_w - window_w) / 2

                return {
                    border = "rounded",
                    relative = "win",
                    width = window_w_int or 30,
                    height = window_h_int or 70,
                    row = center_y,
                    col = center_x,
                }
            end,
        },
        -- width = function()
        --     return math.floor(WIDTH_RATIO * vim.opt.columns:get())
        -- end,
    },
    modified = {
        enable = true,
    },
    tab = {
        sync = {
            open = true,
            close = true,
            ignore = {},
        },
    },
    renderer = {
        add_trailing = true,
        group_empty = true,
        symlink_destination = true,
        highlight_git = "icon",
        highlight_opened_files = "all",
        highlight_modified = "all",
        highlight_hidden = "icon",
        highlight_bookmarks = "name",
        highlight_clipboard = "all",
        hidden_display = "all",
        indent_markers = {
            enable = true,
        },
        icons = {
            web_devicons = {
                folder = {
                    enable = true,
                },
            },
            show = {
                hidden = true,
            },
            bookmarks_placement = "signcolumn",
            git_placement = "before",
            modified_placement = "after",
            hidden_placement = "right_align",
        },
    },
    filters = {
        dotfiles = true,
        custom = {
            "010-installers",
            "Applications",
            "Desktop",
            "Documents",
            "Downloads",
            "Library",
            "Live projects mac",
            "Live\\ projects",
            "Movies",
            "Music",
            "MusicCreation",
            "Pictures",
            "Public",
            "Push3",
            "\\.CFUserTextEncoding",
            "\\.DS_Store",
            "\\.Spotlight-V100",
            "\\.aspnet",
            "\\.cache",
            "\\.colima",
            "\\.docker",
            "\\.dotnet",
            "\\.git",
            "\\.idead",
            "\\.lesshst",
            "\\.local",
            "\\.mounty",
            "\\.node_repl_history",
            "\\.npm",
            "\\.nuget",
            "\\.nvm",
            "\\.python_history",
            "\\.sdkman",
            "\\.templateengine",
            "node_modules",
        },
    },
    hijack_directories = {
        enable = true,
    },
    diagnostics = {
        enable = true,
        show_on_dirs = true,
        show_on_open_dirs = true,
        debounce_delay = 500,
        severity = {
            min = vim.diagnostic.severity.HINT,
            max = vim.diagnostic.severity.ERROR,
        },
        icons = {
            hint = "󰠠",
            info = "󰋼",
            warning = "󰅚",
            error = "󰅚",
        },
    },
    git = {
        enable = true,
    },
    update_focused_file = {
        enable = true,
        update_cwd = true,
    },
    actions = {
        change_dir = {
            restrict_above_cwd = true,
        },
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
vim.keymap.set("n", "<leader>pc", ":NvimTreeClose<CR>", { noremap = true, silent = true })

local function open_nvim_tree(data)
    if vim.fn.isdirectory(data.file) == 1 then -- buffer is not a directory
        vim.cmd.cd(data.file)
        require("nvim-tree.api").tree.open({
            hidden_display = "all",
            focus = false,
            find_file = true,
        })
    end
end
vim.api.nvim_create_autocmd({ "VimEnter" }, {
    callback = function(data)
        if vim.fn.isdirectory(data.file) == 1 then
            vim.schedule(function()
                open_nvim_tree(data)
            end)
        end
    end,
    group = vim.api.nvim_create_augroup("NvimTreeInit", { clear = true }),
})
vim.api.nvim_create_augroup("NvimTreeResize", {
    clear = true,
})

local api = require("nvim-tree.api")
vim.api.nvim_create_autocmd({ "VimResized", "WinResized" }, {
    group = "NvimTreeResize",
    callback = function()
        local winid = api.tree.winid()
        if winid then
            api.tree.reload()
        end
    end,
})
