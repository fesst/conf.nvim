require("motleyfesst.utils")
if is_not_ssh() then
    -- Angular-specific keybindings and settings
    local keymap = vim.keymap.set

    -- Angular component navigation
    keymap("n", "<leader>saf", ":Telescope find_files cwd=src/app<CR>", { desc = "Find Angular Component" })
    keymap("n", "<leader>sag", ":Telescope live_grep cwd=src/app<CR>", { desc = "Search in Angular App" })

    -- Angular CLI commands
    keymap("n", "<leader>gac", ":!ng generate component ", { desc = "Generate Angular Component" })
    keymap("n", "<leader>gas", ":!ng generate service ", { desc = "Generate Angular Service" })
    keymap("n", "<leader>gam", ":!ng generate module ", { desc = "Generate Angular Module" })

    -- Angular-specific settings
    vim.api.nvim_create_autocmd("FileType", {
        pattern = { "typescript", "html" },
        callback = function()
            -- Set tab settings for Angular files
            vim.opt_local.tabstop = 2
            vim.opt_local.shiftwidth = 2
            vim.opt_local.softtabstop = 2
            vim.opt_local.expandtab = true

            -- Enable format on save
            vim.opt_local.formatoptions = vim.opt_local.formatoptions + "c" + "r" + "o"
        end,
    })

    -- Angular template syntax highlighting
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "html",
        callback = function()
            vim.opt_local.syntax = "angular"
        end,
    })
end
