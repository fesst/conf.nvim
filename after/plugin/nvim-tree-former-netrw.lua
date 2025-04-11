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
			'010-installers',
			'Applications', 'Desktop', 'Documents', 'Downloads',
			'Library', 'Live projects mac', 'Live\\ projects',
			'Movies', 'Music', 'MusicCreation', 'Pictures', 'Public', 'Push3',
			'\\.CFUserTextEncoding', '\\.DS_Store', '\\.Spotlight-V100',
			'\\.node_repl_history', '\\.aspnet', '\\.cache', '\\.colima', '\\.cursor',
			'\\.docker', '\\.dotnet', '\\.git', '\\.idead', '\\.lesshst', '\\.local',
			'\\.mounty', '\\.npm', '\\.nuget', '\\.nvm', '\\.oh-my-zsh',
			'\\.python_history', '\\.sdkman','\\.templateengine', '\\.ssh',
			'\\.tmux', '\\.venv', '\\.vim', '\\.vscode', '\\.w3m', 
			'\\.zsh_sessions', 'node_modules',
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
