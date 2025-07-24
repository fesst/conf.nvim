require("motleyfesst.utils")
if IS_NOT_SSH then
    local keymap = vim.keymap.set

    keymap("n", "<leader>taf", ":Telescope find_files cwd=src/app<CR>", { desc = "Find Angular Component" })
    keymap("n", "<leader>tag", ":Telescope live_grep cwd=src/app<CR>", { desc = "Search in Angular App" })

    keymap("n", "<leader>gac", ":!ng generate component ", { desc = "Generate Angular Component" })
    keymap("n", "<leader>gas", ":!ng generate service ", { desc = "Generate Angular Service" })
    keymap("n", "<leader>gam", ":!ng generate module ", { desc = "Generate Angular Module" })

    vim.api.nvim_create_autocmd("FileType", {
        pattern = { "typescript", "html" },
        callback = function()
            vim.opt_local.tabstop = 2
            vim.opt_local.shiftwidth = 2
            vim.opt_local.softtabstop = 2
            vim.opt_local.expandtab = true

            vim.opt_local.formatoptions = vim.opt_local.formatoptions + "c" + "r" + "o"
        end,
    })

    vim.api.nvim_create_autocmd("FileType", {
        pattern = "html",
        callback = function()
            vim.opt_local.syntax = "angular"
        end,
    })
end
