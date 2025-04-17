-- Angular-specific keybindings and settings
local keymap = vim.keymap.set

-- Angular component navigation
keymap('n', '<leader>ac', ':Telescope find_files cwd=src/app<CR>', { desc = 'Find Angular Component' })
keymap('n', '<leader>as', ':Telescope live_grep cwd=src/app<CR>', { desc = 'Search in Angular App' })

-- Angular CLI commands
keymap('n', '<leader>ag', ':!ng generate component ', { desc = 'Generate Angular Component' })
keymap('n', '<leader>as', ':!ng generate service ', { desc = 'Generate Angular Service' })
keymap('n', '<leader>am', ':!ng generate module ', { desc = 'Generate Angular Module' })

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
        vim.opt_local.formatoptions = vim.opt_local.formatoptions + 'c' + 'r' + 'o'
    end
})

-- Angular template syntax highlighting
vim.api.nvim_create_autocmd("FileType", {
    pattern = "html",
    callback = function()
        vim.opt_local.syntax = "angular"
    end
}) 