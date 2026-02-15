require("nvim-tree").setup({
    hijack_cursor = true,
    disable_netrw = true,
    hijack_unnamed_buffer_when_opening = false,
    sync_root_with_cwd = true,
    reload_on_bufenter = true,
    system_open = vim.fn.has("mac") == 1 and { cmd = "open", args = { "-R" } } or nil,
    view = {
        centralize_selection = false,
        side = "left",
        preserve_window_proportions = true,
        relativenumber = true,
        float = { enable = false },
        width = 50,
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
        dotfiles = false,
        custom = {
            "Pictures",
            "Public",
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
        -- update_cwd = true,
    },
    actions = {
        change_dir = {
            restrict_above_cwd = true,
        },
        open_file = {
            quit_on_open = false,
            window_picker = {
                enable = true,
            },
        },
    },
})

vim.keymap.set("n", "<leader>pv", ":NvimTreeFindFile<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>pp", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
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
