vim.g.copilot_no_tab_map = true

vim.api.nvim_set_keymap("n", "<leader>cp", ":Copilot panel<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<C-.>", '<Plug>(copilot-next)', { noremap = false, silent = true })
vim.api.nvim_set_keymap("i", "<C-,>", '<Plug>(copilot-previous)', { noremap = false, silent = true })
vim.api.nvim_set_keymap("i", "<C-\\>", '<Plug>(copilot-dismiss)', { noremap = false, silent = true })
vim.api.nvim_set_keymap("i", "<C-CR>", 'copilot#Accept("<CR>")', { expr = true, silent = true })

-- Turn off Copilot for terminal and buffers 
vim.g.copilot_filetypes = {
	["TelescopePrompt"] = false,
	["terminal"] = false,
	["diff"] = false,
}

-- Configure the Plugin
-- By default, the following key bindings are configured:
--
-- Key	Action
-- Tab	Accept the suggestion
-- Ctrl-]	Dismiss the current suggestion
-- Alt-[	Cycle to the next suggestion
-- Alt-]	Cycle to the previous suggestion
--
-- I have remapped these to more convenient key combinations:
--
-- Key	Action
-- Ctrl+.	Next suggestion
-- Ctrl+,	Previous suggestion
-- Ctrl+\	Dismiss suggestion
-- Ctrl+Enter	Accept suggestion
-- Leader+cp	Open Copilot panel
