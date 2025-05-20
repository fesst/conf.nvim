local keymap = vim.keymap.set

-- Helper function to set up common folding settings
local function setup_folding()
    vim.opt_local.foldmethod = "expr"
    vim.opt_local.foldexpr = "v:lua.vim.lsp.foldexpr() or nvim_treesitter#foldexpr()"
    vim.opt_local.foldenable = true
    vim.opt_local.foldcolumn = "4"
    vim.opt_local.foldlevel = 99
    vim.opt_local.foldminlines = 1
end

-- Helper function to set up common tab settings
local function setup_tabs(tab_size, expand_tab)
    vim.opt_local.tabstop = tab_size
    vim.opt_local.shiftwidth = tab_size
    vim.opt_local.softtabstop = tab_size
    vim.opt_local.expandtab = expand_tab
end

-- Language-specific settings
local function setup_language_settings()
    -- Python
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "python",
        callback = function()
            setup_tabs(4, true)
            vim.opt_local.textwidth = 88 -- Black formatter default
            setup_folding()
        end,
    })

    -- JavaScript/TypeScript
    vim.api.nvim_create_autocmd("FileType", {
        pattern = { "javascript", "typescript", "typescriptreact" },
        callback = function()
            setup_tabs(2, true)
            setup_folding()
        end,
    })

    -- HTML/CSS
    vim.api.nvim_create_autocmd("FileType", {
        pattern = { "html", "css", "scss", "less" },
        callback = function()
            setup_tabs(2, true)
            setup_folding()
        end,
    })

    -- Go
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "go",
        callback = function()
            setup_tabs(4, false)
            setup_folding()
        end,
    })

    -- C/C++
    vim.api.nvim_create_autocmd("FileType", {
        pattern = { "c", "cpp" },
        callback = function()
            setup_tabs(4, true)
            setup_folding()
        end,
    })

    -- Rust
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "rust",
        callback = function()
            -- Use LSP-based folding for Rust
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

    -- LaTeX
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "tex",
        callback = function()
            vim.opt_local.textwidth = 80
            vim.opt_local.wrap = true
            vim.opt_local.linebreak = true
            setup_folding()
        end,
    })

    -- Lua
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "lua",
        callback = function()
            setup_folding()
        end,
    })

    -- Shell scripts
    vim.api.nvim_create_autocmd("FileType", {
        pattern = { "sh", "bash", "zsh" },
        callback = function()
            setup_folding()
        end,
    })

    -- JSON/YAML/TOML
    vim.api.nvim_create_autocmd("FileType", {
        pattern = { "json", "yaml", "toml" },
        callback = function()
            setup_folding()
        end,
    })

    -- Markdown and other text files
    vim.api.nvim_create_autocmd("FileType", {
        pattern = { "markdown", "md", "txt", "text" },
        callback = function()
            setup_folding()
        end,
    })

    -- SQL
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "sql",
        callback = function()
            setup_tabs(4, true)
            setup_folding()
            -- Enable SQL syntax highlighting
            vim.opt_local.syntax = "sql"
            -- Set comment string for SQL
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
            -- Explain current query
            keymap("v", "<leader>se", ":!psql -c 'EXPLAIN ANALYZE ' . getreg('*')<CR>", { desc = "Explain selected query" })
            -- Execute current query
            keymap("v", "<leader>sr", ":!psql -c " .. getreg('*') .. "<CR>", { desc = "Run selected query" })
            -- Show table structure
            keymap("n", "<leader>st", ":!psql -c '\\d ' . expand('<cword>')<CR>", { desc = "Show table structure" })
            -- Show database size
            keymap("n", "<leader>sd", ":!psql -c '\\l+'<CR>", { desc = "Show database sizes" })
            -- Show table sizes
            keymap("n", "<leader>ss", ":!psql -c '\\dt+'<CR>", { desc = "Show table sizes" })
            -- Show index usage
            keymap("n", "<leader>si", ":!psql -c 'SELECT * FROM pg_stat_user_indexes'<CR>", { desc = "Show index usage" })
            -- Show long-running queries
            keymap("n", "<leader>sl", ":!psql -c 'SELECT * FROM pg_stat_activity WHERE state = ''active'''<CR>", { desc = "Show long-running queries" })
            -- Show locks
            keymap("n", "<leader>sk", ":!psql -c 'SELECT * FROM pg_locks'<CR>", { desc = "Show locks" })
            -- Show vacuum status
            keymap("n", "<leader>sv", ":!psql -c 'SELECT * FROM pg_stat_user_tables'<CR>", { desc = "Show vacuum status" })
        end,
    })
end

-- Language-specific keybindings
local function setup_language_keybindings()
    -- Python
    keymap("n", "<leader>yr", ":!python %<CR>", { desc = "Run Python file" })
    keymap("n", "<leader>yt", ":!python -m pytest %<CR>", { desc = "Run Python tests" })

    -- Go
    keymap("n", "<leader>yr", ":!go run %<CR>", { desc = "Run Go file" })
    keymap("n", "<leader>yt", ":!go test %<CR>", { desc = "Run Go tests" })

    -- Rust
    keymap("n", "<leader>yr", ":!cargo run<CR>", { desc = "Run Rust project" })
    keymap("n", "<leader>yt", ":!cargo test<CR>", { desc = "Run Rust tests" })

    -- JavaScript/TypeScript
    keymap("n", "<leader>yr", ":!node %<CR>", { desc = "Run JavaScript file" })
    keymap("n", "<leader>yt", ":!npm test<CR>", { desc = "Run JavaScript tests" })

    -- LaTeX
    keymap(
        "n",
        "<leader>yb",
        ":!latexmk -pdf -synctex=1 -interaction=nonstopmode %<CR>",
        { desc = "Build LaTeX document" }
    )
    keymap("n", "<leader>yv", ":!open -a Skim %:r.pdf<CR>", { desc = "View LaTeX PDF" })

    -- Docker
    keymap("n", "<leader>yd", ":!docker build .<CR>", { desc = "Build Docker image" })
    keymap("n", "<leader>yr", ":!docker run<CR>", { desc = "Run Docker container" })

    -- Git (removed as they conflict with fugitive)
    -- keymap('n', '<leader>gs', ':G<CR>', { desc = 'Git status' })
    -- keymap('n', '<leader>gc', ':Git commit<CR>', { desc = 'Git commit' })
    -- keymap('n', '<leader>gp', ':Git push<CR>', { desc = 'Git push' })
end

-- Initialize
setup_language_settings()
setup_language_keybindings()
