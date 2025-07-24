require("motleyfesst.utils")

local function setup_persistent_folding()
    local view_dir = vim.fn.stdpath("data") .. "/view"
    if vim.fn.isdirectory(view_dir) == 0 then
        vim.fn.mkdir(view_dir, "p")
    end
    vim.opt.viewdir = view_dir
    vim.opt.viewoptions = "folds,cursor,curdir,slash,unix"
end

setup_persistent_folding()

local function setup_nvim_tree_integration()
    local status_ok, nvim_tree = pcall(require, "nvim-tree")
    if status_ok and nvim_tree.actions and nvim_tree.actions.open_file then
        local original_open_file = nvim_tree.actions.open_file
        nvim_tree.actions.open_file = function(node)
            original_open_file(node)
            vim.defer_fn(function()
                pcall(vim.cmd, "silent! loadview")
            end, 50)
        end
    end
end

vim.defer_fn(function()
    setup_nvim_tree_integration()
end, 100)

vim.keymap.set("n", "<leader>vs", ":silent! mkview<CR>", { desc = "Save view (folding state)" })
vim.keymap.set("n", "<leader>vl", ":silent! loadview<CR>", { desc = "Load view (folding state)" })
vim.keymap.set("n", "<leader>vr", ":silent! loadview!<CR>", { desc = "Load view (force)" })

local persistent_folding_group = vim.api.nvim_create_augroup("PersistentFolding", { clear = true })

vim.api.nvim_create_autocmd("BufLeave", {
    pattern = "*",
    callback = function()
        if vim.bo.filetype ~= "" and vim.bo.buftype == "" then
            pcall(vim.cmd, "silent! mkview")
        end
    end,
    group = persistent_folding_group,
})

vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*",
    callback = function()
        if vim.bo.filetype ~= "" and vim.bo.buftype == "" then
            pcall(vim.cmd, "silent! loadview")
        end
    end,
    group = persistent_folding_group,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function()
        if vim.bo.buftype == "" then
            -- Add a small delay to ensure filetype is fully set
            vim.defer_fn(function()
                pcall(vim.cmd, "silent! loadview")
            end, 10)
        end
    end,
    group = persistent_folding_group,
})

vim.api.nvim_create_autocmd("WinLeave", {
    pattern = "*",
    callback = function()
        if vim.bo.filetype ~= "" and vim.bo.buftype == "" then
            pcall(vim.cmd, "silent! mkview")
        end
    end,
    group = persistent_folding_group,
})
