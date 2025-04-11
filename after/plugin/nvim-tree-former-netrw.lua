require("nvim-tree").setup {
	sync_root_with_cwd = true,
	reload_on_bufenter = true,
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
			'\\.git', 'node_modules', '.cache',
			'Applications', 'Library', 'MusicCreation',
			'\\.aspnet', '\\.colima', '\\.local', '\\.npm', '\\.nvm',
			'\\.oh-my-zsh', '\\.venv', '\\.docker', 'Movies', 'Public',
			'Pictures', 'Desktop', 'Documents', 'Downloads',
			'Live Projects', 'Live project mac', '010-installers',
			'\\.zsh_sessions', 'Push3',
			'\\.CFUserTextEncoding', '\\.DS_Store', '\\.lesshst',
			'\\.Spotlight-V100','\\.node_repl_history',
			'\\.python_history', '\\.sdkman','\\.templateengine',
			'\\.mounty', '\\.nuget', '\\.dotnet', '\\.vim',
			'\\.vscode', '\\.idead', '\\.ssh', '\\.tmux',
			'\\.w3m', '\\.cursor'
		}
	}
}
vim.api.nvim_set_keymap("n", "<leader>pv", ":NvimTreeFindFile<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>pV", ":NvimTreeFindFileToggle<CR>", { noremap = true, silent = true })

-- from netrw.lua
--vim.g.netrw_banner = 0 -- disable that anoying Netrw banner
--vim.g.netrw_browser_split = 4 -- open in a prior window
--vim.g.netrw_list_hide = '^\\./\\?$,^\\.\\./\\?$' -- hide ./ and ../
--vim.g.netrw_liststyle = 3
