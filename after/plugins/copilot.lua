-- Copilot configuration
vim.g.copilot_no_tab_map = true
vim.g.copilot_assume_mapped = true

-- Turn off Copilot for terminal and buffers
vim.g.copilot_filetypes = {
    ["TelescopePrompt"] = false,
    ["terminal"] = false,
    ["diff"] = false,
}

-- Mappings are now in lua/motleyfesst/remap.lua
