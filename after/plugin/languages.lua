require("motleyfesst.utils")

if IS_NOT_SSH() then
    local keymap = vim.keymap.set

    local function setup_tabs(tab_size, expand_tab)
        vim.opt_local.tabstop = tab_size
        vim.opt_local.shiftwidth = tab_size
        vim.opt_local.softtabstop = tab_size
        vim.opt_local.expandtab = expand_tab
    end

    local function setup_language_settings()
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "python",
            callback = function()
                setup_tabs(4, true)
                vim.opt_local.textwidth = 88 -- Black formatter default
            end,
        })
        vim.api.nvim_create_autocmd("FileType", {
            pattern = { "javascript", "typescript", "typescriptreact" },
            callback = function()
                setup_tabs(2, true)
            end,
        })
        vim.api.nvim_create_autocmd("FileType", {
            pattern = { "html", "css", "scss", "less" },
            callback = function()
                setup_tabs(2, true)
            end,
        })
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "go",
            callback = function()
                setup_tabs(4, false)
            end,
        })
        vim.api.nvim_create_autocmd("FileType", {
            pattern = { "c", "cpp" },
            callback = function()
                setup_tabs(4, true)
            end,
        })
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "rust",
            callback = function()
                vim.opt_local.foldmethod = "expr"
                vim.opt_local.foldexpr = "v:lua.vim.lsp.foldexpr()"
                vim.opt_local.foldenable = true
                vim.opt_local.foldcolumn = "4"
                vim.opt_local.foldlevel = 99
                vim.opt_local.foldminlines = 1

                setup_tabs(4, true)
                vim.opt_local.colorcolumn = "100"
                vim.opt_local.textwidth = 100
                vim.opt_local.formatoptions:append("c") -- Auto-wrap comments
                vim.opt_local.formatoptions:append("q") -- Allow formatting of comments with 'gq'
                vim.opt_local.formatoptions:append("r") -- Auto-insert comment leader after hitting <Enter>
                vim.opt_local.formatoptions:append("n") -- Recognize numbered lists
                vim.opt_local.formatoptions:append("j") -- Remove comment leader when joining lines
            end,
        })
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "tex",
            callback = function()
                vim.opt_local.textwidth = 80
                vim.opt_local.wrap = true
                vim.opt_local.linebreak = true
            end,
        })
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "sql",
            callback = function()
                setup_tabs(4, true)
                vim.opt_local.syntax = "sql"
                vim.opt_local.commentstring = "-- %s"
                -- PostgreSQL-specific settings
                vim.opt_local.formatoptions:append("c") -- Auto-wrap comments
                vim.opt_local.formatoptions:append("r") -- Auto-insert comment leader after hitting <Enter>
                vim.opt_local.formatoptions:append("o") -- Auto-insert comment leader after 'o' or 'O'
                vim.opt_local.formatoptions:append("q") -- Allow formatting of comments with 'gq'
                vim.opt_local.formatoptions:append("n") -- Recognize numbered lists
                vim.opt_local.formatoptions:append("j") -- Remove comment leader when joining lines
                -- Set text width for SQL files
                vim.opt_local.textwidth = 100

                -- PostgreSQL-specific keybindings
                local opts = { buffer = true, silent = true }
                -- Format current SQL file
                keymap("n", "<leader>sf", ":!pg_format -i %<CR>", { desc = "Format SQL file" })
                keymap("v", "<leader>se", ":!psql -c 'EXPLAIN ANALYZE ' . vim.fn.getreg('*')<CR>",
                    { desc = "Explain selected query" })
                keymap("v", "<leader>sr", ":!psql -c " .. vim.fn.getreg("*") .. "<CR>", { desc = "Run selected query" })
                keymap("n", "<leader>st", ":!psql -c '\\d ' . expand('<cword>')<CR>", { desc = "Show table structure" })
                keymap("n", "<leader>sd", ":!psql -c '\\l+'<CR>", { desc = "Show database sizes" })
                keymap("n", "<leader>ss", ":!psql -c '\\dt+'<CR>", { desc = "Show table sizes" })
                keymap("n", "<leader>si", ":!psql -c 'SELECT * FROM pg_stat_user_indexes'<CR>",
                    { desc = "Show index usage" })
                keymap("n", "<leader>sl", ":!psql -c 'SELECT * FROM pg_stat_activity WHERE state = ''active'''<CR>",
                    { desc = "Show long-running queries" })
                keymap("n", "<leader>sk", ":!psql -c 'SELECT * FROM pg_locks'<CR>", { desc = "Show locks" })
                keymap("n", "<leader>sv", ":!psql -c 'SELECT * FROM pg_stat_user_tables'<CR>",
                    { desc = "Show vacuum status" })
            end,
        })
    end

    local function setup_language_keybindings()
        keymap("n", "<leader>yr", ":!python %<CR>", { desc = "Run Python file" })
        keymap("n", "<leader>yt", ":!python -m pytest %<CR>", { desc = "Run Python tests" })

        keymap("n", "<leader>yr", ":!go run %<CR>", { desc = "Run Go file" })
        keymap("n", "<leader>yt", ":!go test %<CR>", { desc = "Run Go tests" })

        keymap("n", "<leader>yr", ":!cargo run<CR>", { desc = "Run Rust project" })
        keymap("n", "<leader>yt", ":!cargo test<CR>", { desc = "Run Rust tests" })

        keymap("n", "<leader>yr", ":!node %<CR>", { desc = "Run JavaScript file" })
        keymap("n", "<leader>yt", ":!npm test<CR>", { desc = "Run JavaScript tests" })

        keymap("n", "<leader>yb", ":!latexmk -pdf -synctex=1 -interaction=nonstopmode %<CR>",
            { desc = "Build LaTeX document" })
        keymap("n", "<leader>yv", ":!open -a Skim %:r.pdf<CR>", { desc = "View LaTeX PDF" })

        keymap("n", "<leader>yd", ":!docker build .<CR>", { desc = "Build Docker image" })
        keymap("n", "<leader>yr", ":!docker run<CR>", { desc = "Run Docker container" })
    end

    -- Initialize
    setup_language_settings()
    setup_language_keybindings()
end
