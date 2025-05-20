-- Copilot configuration
vim.g.copilot_no_tab_map = true
vim.g.copilot_assume_mapped = true
-- Copilot mappings
vim.api.nvim_set_keymap("n", "<leader>cp", ":Copilot panel<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<C-;>", 'copilot#Accept("\\<CR>")', { expr = true, silent = true })
vim.api.nvim_set_keymap("i", "<C-.>", "<Plug>(copilot-next)", { silent = true, desc = "Next suggestion" })
vim.api.nvim_set_keymap("i", "<C-,>", "<Plug>(copilot-previous)", { silent = true, desc = "Previous suggestion" })
vim.api.nvim_set_keymap("i", "<C-\\>", "<Plug>(copilot-dismiss)", { silent = true, desc = "Dismiss suggestion" })


-- Turn off Copilot for terminal and buffers
vim.g.copilot_filetypes = {
    ["TelescopePrompt"] = false,
    ["terminal"] = false,
    ["diff"] = false,
}

-- Mappings are now in lua/motleyfesst/remap.lua
