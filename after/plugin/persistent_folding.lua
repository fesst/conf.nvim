require("motleyfesst.utils")

-- Simple persistent folding setup
local function setup_persistent_folding()
    -- Create view directory
    local view_dir = vim.fn.stdpath("data") .. "/view"
    if vim.fn.isdirectory(view_dir) == 0 then
        vim.fn.mkdir(view_dir, "p")
    end

    -- Set view directory
    vim.opt.viewdir = view_dir

    -- Enable view options for folding (configured in lua/motleyfesst/set.lua)
end

-- Set up persistent folding
setup_persistent_folding()

-- Key mappings for manual view management
vim.keymap.set("n", "<leader>vs", ":mkview<CR>", { desc = "Save view (folding state)" })
vim.keymap.set("n", "<leader>vl", ":loadview<CR>", { desc = "Load view (folding state)" })
vim.keymap.set("n", "<leader>vr", ":loadview!<CR>", { desc = "Load view (force)" })

-- Simple auto-save on buffer leave
vim.api.nvim_create_autocmd("BufLeave", {
    pattern = "*",
    callback = function()
        if vim.bo.filetype ~= "" and vim.bo.buftype == "" then
            vim.cmd("mkview")
        end
    end,
})


-- Auto-load view when entering buffer
vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*",
    callback = function()
        if vim.bo.filetype ~= "" and vim.bo.buftype == "" then
            vim.cmd("loadview")
        end
    end,
})

-- Auto-save view when leaving window
vim.api.nvim_create_autocmd("WinLeave", {
    pattern = "*",
    callback = function()
        if vim.bo.filetype ~= "" and vim.bo.buftype == "" then
            vim.cmd("mkview")
        end
    end,
})
