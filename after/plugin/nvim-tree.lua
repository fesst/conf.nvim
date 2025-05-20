-- Disable netrw (former netrw configuration)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Function to open nvim-tree on directory open
local function open_nvim_tree(data)
    -- buffer is a directory
    local directory = vim.fn.isdirectory(data.file) == 1

    if not directory then
        return
    end

    -- change to the directory
    vim.cmd.cd(data.file)

    -- open the tree
    require("nvim-tree.api").tree.open()
end

vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })

-- Nvim-tree configuration
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
            "\\.node_repl_history",
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
            "\\.npm",
            "\\.nuget",
            "\\.nvm",
            "\\.oh-my-zsh",
            "\\.python_history",
            "\\.sdkman",
            "\\.templateengine",
            "\\.ssh",
            "\\.tmux",
            "\\.venv",
            "\\.vim",
            "\\.vscode",
            "\\.w3m",
            "\\.zsh_sessions",
            "node_modules",
        },
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

-- Key mappings
vim.api.nvim_set_keymap("n", "<leader>pv", ":NvimTreeFindFile<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>p-", ":NvimTreeToggle<CR>", { noremap = true, silent = true }) 