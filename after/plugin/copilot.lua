require("motleyfesst.utils")
if is_not_ssh() then
    -- Copilot configuration
    vim.g.copilot_no_tab_map = true
    vim.g.copilot_assume_mapped = true
    vim.g.copilot_enabled = true
    vim.g.copilot_tab_fallback = ""

    -- Enable Copilot for all filetypes except those explicitly disabled
    vim.g.copilot_filetypes = {
        ["TelescopePrompt"] = false,
        ["terminal"] = false,
        ["diff"] = false,
    }

    -- Copilot mappings
    vim.api.nvim_set_keymap("n", "<leader>cp", ":Copilot panel<CR>", { noremap = true, silent = true })
    vim.api.nvim_set_keymap("i", "<C-;>", 'copilot#Accept("\\<CR>")', { expr = true, silent = true })
    vim.api.nvim_set_keymap("i", "<C-.>", "<Plug>(copilot-next)", { silent = true, desc = "Next suggestion" })
    vim.api.nvim_set_keymap("i", "<C-,>", "<Plug>(copilot-previous)", { silent = true, desc = "Previous suggestion" })
    vim.api.nvim_set_keymap("i", "<C-\\>", "<Plug>(copilot-dismiss)", { silent = true, desc = "Dismiss suggestion" })
end
