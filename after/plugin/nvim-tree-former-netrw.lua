require("nvim-tree").setup {
	--sync_root_with_cwd = true,
	reload_on_bufenter = true,

}

vim.api.nvim_set_keymap("n", "<leader>pv", ":NvimTreeFindFile<CR>", { noremap = true, silent = true })

vim.api.nvim_set_keymap("n", "<leader>pV", ":NvimTreeFindFileToggle<CR>", { noremap = true, silent = true })


-- from netrw.lua
--vim.g.netrw_banner = 0 -- disable that anoying Netrw banner
--vim.g.netrw_browser_split = 4 -- open in a prior window
--vim.g.netrw_list_hide = '^\\./\\?$,^\\.\\./\\?$' -- hide ./ and ../
--vim.g.netrw_liststyle = 3
