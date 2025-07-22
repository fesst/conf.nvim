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
local buf_leave_timer = nil
vim.api.nvim_create_autocmd("BufLeave", {
    pattern = "*",
    callback = function()
        if vim.bo.filetype ~= "" and vim.bo.buftype == "" then
            if buf_leave_timer then
                vim.fn.timer_stop(buf_leave_timer)
            end
            buf_leave_timer = vim.defer_fn(function()
                vim.cmd("mkview")
            end, 200) -- 200ms debounce interval
        end
    end,
})


-- Auto-load view when entering buffer
local buf_enter_timer = nil
vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*",
    callback = function()
        if vim.bo.filetype ~= "" and vim.bo.buftype == "" then
            if buf_enter_timer then
                vim.fn.timer_stop(buf_enter_timer)
            end
            buf_enter_timer = vim.defer_fn(function()
                vim.cmd("loadview")
            end, 200) -- 200ms debounce interval
        end
    end,
})

-- Auto-save view when leaving window
local win_leave_timer = nil
vim.api.nvim_create_autocmd("WinLeave", {
    pattern = "*",
    callback = function()
        if vim.bo.filetype ~= "" and vim.bo.buftype == "" then
            if win_leave_timer then
                vim.fn.timer_stop(win_leave_timer)
            end
            win_leave_timer = vim.defer_fn(function()
                vim.cmd("mkview")
            end, 200) -- 200ms debounce interval
        end
    end,
})
