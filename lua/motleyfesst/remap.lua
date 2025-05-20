-- Copilot mappings
vim.api.nvim_set_keymap("n", "<leader>cp", ":Copilot panel<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<C-l>", 'copilot#Accept("\\<CR>")', { expr = true, silent = true })
vim.api.nvim_set_keymap("i", "<C-.>", "<Plug>(copilot-next)", { silent = true, desc = "Next suggestion" })
vim.api.nvim_set_keymap("i", "<C-,>", "<Plug>(copilot-previous)", { silent = true, desc = "Previous suggestion" })
vim.api.nvim_set_keymap("i", "<C-\\>", "<Plug>(copilot-dismiss)", { silent = true, desc = "Dismiss suggestion" })

