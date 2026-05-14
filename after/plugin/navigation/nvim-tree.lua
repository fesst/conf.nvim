require("nvim-tree").setup({
    hijack_cursor = true,
    disable_netrw = true,
    hijack_unnamed_buffer_when_opening = false,
    sync_root_with_cwd = true,
    reload_on_bufenter = true,
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

local api = require("nvim-tree.api")

-- track last opened mode: "float" or "pane" (pane = current/side window)
local last_tree_mode = vim.g.__nvim_tree_last_mode or "pane"

local function open_nvim_tree(data)
    if vim.fn.isdirectory(data.file) == 1 then -- buffer is a directory
        vim.cmd.cd(data.file)
        api.tree.open({
            hidden_display = "all",
            focus = false,
            find_file = true,
        })
    end
end

local function is_tree_open()
    local winid = api.tree.winid()
    return winid ~= nil and winid ~= 0
end

local function is_tree_floating()
    local winid = api.tree.winid()
    if not winid or winid == 0 then
        return false
    end
    local ok, cfg = pcall(vim.api.nvim_win_get_config, winid)
    if not ok or not cfg then
        return false
    end
    return type(cfg.relative) == "string" and cfg.relative ~= ""
end

local function close_tree()
    if is_tree_open() then
        api.tree.close()
    end
end

local function open_tree_pane()
    -- If a floating tree is present close it and ensure float is disabled in setup
    if is_tree_floating() then
        close_tree()
    end
    -- ensure float is disabled so api.tree.open opens a pane
    require("nvim-tree").setup({ view = { float = { enable = false } } })

    -- open side pane
    api.tree.open({ hidden_display = "all", focus = true, find_file = true })
    last_tree_mode = "pane"
    vim.g.__nvim_tree_last_mode = last_tree_mode
end

local function open_tree_float()
    -- If a non-floating tree is open, close it first
    if is_tree_open() and not is_tree_floating() then
        close_tree()
    end

    -- configure float window size centered across editor
    local cols = vim.o.columns
    local lines = vim.o.lines
    local width = math.floor(math.max(30, math.min(80, cols * 0.5)))
    local height = math.floor(math.max(10, math.min(30, lines * 0.5)))
    local row = math.floor((lines - height) / 2 - 1)
    local col = math.floor((cols - width) / 2)

    -- enable float for this open by reconfiguring nvim-tree float view then opening
    require("nvim-tree").setup({
        view = {
            float = {
                enable = true,
                open_win_config = {
                    relative = "editor",
                    border = "rounded",
                    width = width,
                    height = height,
                    row = row,
                    col = col,
                },
            },
        },
    })

    api.tree.open({ find_file = true, focus = true })
    last_tree_mode = "float"
    vim.g.__nvim_tree_last_mode = last_tree_mode
end

-- mappings
vim.keymap.set("n", "<leader>pv", function()
    open_tree_float()
end, { noremap = true, silent = true })

vim.keymap.set("n", "<leader>pb", function()
    open_tree_pane()
end, { noremap = true, silent = true })

vim.keymap.set("n", "<leader>pp", function()
    -- toggle: if open -> close, else open last used mode (fallback to float)
    if is_tree_open() then
        close_tree()
        return
    end
    if last_tree_mode == "pane" then
        open_tree_pane()
    else
        open_tree_float()
    end
end, { noremap = true, silent = true })

vim.keymap.set("n", "<leader>pc", ":NvimTreeClose<CR>", { noremap = true, silent = true })

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
vim.api.nvim_create_autocmd({ "VimResized", "WinResized" }, {
    group = vim.api.nvim_create_augroup("NvimTreeResize", { clear = true }),
    callback = function()
        local winid = api.tree.winid()
        if winid then
            api.tree.reload()
        end
    end,
})
