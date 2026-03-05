local ssh_utils = require("motleyfesst.ssh_utils")

if ssh_utils.IS_MAC() then
    if vim.fn.exists(":Copilot") == 0 then
        return
    end

    vim.g.copilot_no_tab_map = true
    vim.g.copilot_assume_mapped = true
    vim.g.copilot_enabled = true
    vim.g.copilot_tab_fallback = ""

    vim.g.copilot_filetypes = {
        ["TelescopePrompt"] = false,
        ["terminal"] = true,
        ["diff"] = false,
    }

    -- Copilot mappings
    vim.api.nvim_set_keymap("n", "<leader>cp", ":Copilot panel<CR>", { noremap = true, silent = true })
    vim.api.nvim_set_keymap("i", "<C-;>", 'copilot#Accept("\\<CR>")', { expr = true, silent = true })
    vim.api.nvim_set_keymap("i", "<C-.>", "<Plug>(copilot-next)", { silent = true, desc = "Next suggestion" })
    vim.api.nvim_set_keymap("i", "<C-,>", "<Plug>(copilot-previous)", { silent = true, desc = "Previous suggestion" })
    vim.api.nvim_set_keymap("i", "<C-\\>", "<Plug>(copilot-dismiss)", { silent = true, desc = "Dismiss suggestion" })
end
