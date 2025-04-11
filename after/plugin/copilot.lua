vim.g.copilot_no_tab_map = true

vim.api.nvim_set_keymap("n", "<leader>cp", ":Copilot panel<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<C-J>", 'copilot#Accept("\\<CR>")', { expr = true, silent = true })
vim.api.nvim_set_keymap("i", "<C-[>", 'copilot#Previous()', { expr = true, silent = true })
vim.api.nvim_set_keymap("i", "<C-]>", 'copilot#Next()', { expr = true, silent = true })
vim.api.nvim_set_keymap("i", "<C-\\>", 'copilot#Dismiss()', { expr = true, silent = true })

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
-- I have the Alt key on my system reserved for another application, so I chose to remap these to Ctrl-\, Ctrl-j, and Ctrl-k respectively. I did this by adding the following to my Neovim config. The Neovim config file is typically located at ~/.config/nvim/config.
--
-- imap <silent> <C-j> <Plug>(copilot-next)
-- imap <silent> <C-k> <Plug>(copilot-previous)
-- imap <silent> <C-\> <Plug>(copilot-dismiss)
