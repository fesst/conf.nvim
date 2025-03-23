vim.g.copilot_no_tab_map = true

vim.api.nvim_set_keymap("i", "<C-J>", 'copilot#Accept("\\<CR>")', { expr = true, silent = true })

vim.api.nvim_set_keymap("n", "<leader>cp", ":Copilot panel<CR>", { noremap = true, silent = true })

vim.api.nvim_set_keymap("i", "<C-[>", 'copilot#Previous()', { expr = true, silent = true })
vim.api.nvim_set_keymap("i", "<C-]>", 'copilot#Next()', { expr = true, silent = true })
-- Turn off Copilot for terminal and buffers 
vim.g.copilot_filetypes = {
	["TelescopePrompt"] = false,
	["terminal"] = false,
	["diff"] = false,
}

