local ssh_utils = require("motleyfesst.ssh_utils")

if ssh_utils.IS_LOCAL() then
    local keymap = vim.keymap.set
    local language_group = vim.api.nvim_create_augroup("LanguageSpecificConfig", { clear = true })

    local function setup_tabs(tab_size, expand_tab)
        vim.opt_local.tabstop = tab_size
        vim.opt_local.shiftwidth = tab_size
        vim.opt_local.softtabstop = tab_size
        vim.opt_local.expandtab = expand_tab
    end

    local function setup_language_settings()
        vim.api.nvim_create_autocmd("FileType", {
            group = language_group,
            pattern = "python",
            callback = function()
                setup_tabs(4, true)
                vim.opt_local.textwidth = 88 -- Black formatter default
            end,
        })
        vim.api.nvim_create_autocmd("FileType", {
            group = language_group,
            pattern = { "javascript", "typescript", "typescriptreact" },
            callback = function()
                setup_tabs(2, true)
            end,
        })
        vim.api.nvim_create_autocmd("FileType", {
            group = language_group,
            pattern = { "java" },
            callback = function()
                setup_tabs(2, true)
            end,
        })
        vim.api.nvim_create_autocmd("FileType", {
            group = language_group,
            pattern = { "html", "css", "scss", "less" },
            callback = function()
                setup_tabs(2, true)
            end,
        })
        vim.api.nvim_create_autocmd("FileType", {
            group = language_group,
            pattern = "tex",
            callback = function()
                vim.opt_local.textwidth = 80
                vim.opt_local.wrap = true
                vim.opt_local.linebreak = true
            end,
        })
    end

    local function setup_language_keybindings()
        vim.api.nvim_create_autocmd("FileType", {
            group = language_group,
            pattern = "python",
            callback = function(ev)
                keymap("n", "<leader>yr", ":!python %<CR>", { buffer = ev.buf, desc = "Run Python file" })
                keymap("n", "<leader>yt", ":!python -m pytest %<CR>", { buffer = ev.buf, desc = "Run Python tests" })
            end,
        })

        -- Disabled lang keybindings in after/discharged/lsp/lang_keybindings.lua

        vim.api.nvim_create_autocmd("FileType", {
            group = language_group,
            pattern = { "javascript", "typescript", "typescriptreact" },
            callback = function(ev)
                keymap("n", "<leader>yr", ":!node %<CR>", { buffer = ev.buf, desc = "Run JavaScript file" })
                keymap("n", "<leader>yt", ":!npm test<CR>", { buffer = ev.buf, desc = "Run JavaScript tests" })
            end,
        })

        vim.api.nvim_create_autocmd("FileType", {
            group = language_group,
            pattern = "tex",
            callback = function(ev)
                keymap(
                    "n",
                    "<leader>yb",
                    ":!latexmk -pdf -synctex=1 -interaction=nonstopmode %<CR>",
                    { buffer = ev.buf, desc = "Build LaTeX document" }
                )
                keymap("n", "<leader>yv", ":!open %:r.pdf<CR>", { buffer = ev.buf, desc = "View LaTeX PDF" })
            end,
        })

    end

    -- Initialize
    setup_language_settings()
    setup_language_keybindings()
end
