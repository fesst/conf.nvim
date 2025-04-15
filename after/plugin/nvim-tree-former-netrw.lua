require("nvim-tree").setup {
    sync_root_with_cwd = true,
    reload_on_bufenter = true,
    hijack_directories = {
        enable = false
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
            '010-installers',
            'Applications', 'Desktop', 'Documents', 'Downloads',
            'Library', 'Live projects mac', 'Live\\ projects',
            'Movies', 'Music', 'MusicCreation', 'Pictures', 'Public', 'Push3',
            '\\.CFUserTextEncoding', '\\.DS_Store', '\\.Spotlight-V100',
            '\\.node_repl_history', '\\.aspnet', '\\.cache', '\\.colima',
            '\\.docker', '\\.dotnet', '\\.git', '\\.idead', '\\.lesshst', '\\.local',
            '\\.mounty', '\\.npm', '\\.nuget', '\\.nvm', '\\.oh-my-zsh',
            '\\.python_history', '\\.sdkman','\\.templateengine', '\\.ssh',
            '\\.tmux', '\\.venv', '\\.vim', '\\.vscode', '\\.w3m',
            '\\.zsh_sessions', 'node_modules',
        }
    },
    actions = {
        open_file = {
            quit_on_open = true,
        },
    },
}
vim.api.nvim_set_keymap("n", "<leader>pv", ":NvimTreeFindFileToggle<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>pV", ":NvimTreeFindFile<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>p-", ":NvimTreeExplore<CR>", { noremap = true, silent = true })
