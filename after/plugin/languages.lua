local keymap = vim.keymap.set

-- Language-specific settings
local function setup_language_settings()
    -- Python
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "python",
        callback = function()
            vim.opt_local.tabstop = 4
            vim.opt_local.shiftwidth = 4
            vim.opt_local.softtabstop = 4
            vim.opt_local.expandtab = true
            vim.opt_local.textwidth = 88 -- Black formatter default
            vim.opt_local.foldmethod = "indent"  -- Use indentation for folding
            vim.opt_local.foldenable = true
            vim.opt_local.foldcolumn = "4"  -- Show fold column
            vim.opt_local.foldlevel = 99    -- Start with all folds open
            vim.opt_local.foldminlines = 1  -- Minimum lines for a fold
        end
    })

    -- JavaScript/TypeScript
    vim.api.nvim_create_autocmd("FileType", {
        pattern = { "javascript", "typescript", "typescriptreact" },
        callback = function()
            vim.opt_local.tabstop = 2
            vim.opt_local.shiftwidth = 2
            vim.opt_local.softtabstop = 2
            vim.opt_local.expandtab = true
            vim.opt_local.foldmethod = "indent"
            vim.opt_local.foldenable = true
            vim.opt_local.foldcolumn = "4"
            vim.opt_local.foldlevel = 99
            vim.opt_local.foldminlines = 1
        end
    })

    -- HTML/CSS
    vim.api.nvim_create_autocmd("FileType", {
        pattern = { "html", "css", "scss", "less" },
        callback = function()
            vim.opt_local.tabstop = 2
            vim.opt_local.shiftwidth = 2
            vim.opt_local.softtabstop = 2
            vim.opt_local.expandtab = true
            vim.opt_local.foldmethod = "indent"
            vim.opt_local.foldenable = true
            vim.opt_local.foldcolumn = "4"
            vim.opt_local.foldlevel = 99
            vim.opt_local.foldminlines = 1
        end
    })

    -- Go
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "go",
        callback = function()
            vim.opt_local.tabstop = 4
            vim.opt_local.shiftwidth = 4
            vim.opt_local.softtabstop = 4
            vim.opt_local.noexpandtab = true
            vim.opt_local.foldmethod = "indent"
            vim.opt_local.foldenable = true
            vim.opt_local.foldcolumn = "4"
            vim.opt_local.foldlevel = 99
            vim.opt_local.foldminlines = 1
        end
    })

    -- C/C++
    vim.api.nvim_create_autocmd("FileType", {
        pattern = { "c", "cpp" },
        callback = function()
            vim.opt_local.tabstop = 4
            vim.opt_local.shiftwidth = 4
            vim.opt_local.softtabstop = 4
            vim.opt_local.expandtab = true
            vim.opt_local.foldmethod = "indent"
            vim.opt_local.foldenable = true
            vim.opt_local.foldcolumn = "4"
            vim.opt_local.foldlevel = 99
            vim.opt_local.foldminlines = 1
        end
    })

    -- Rust
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "rust",
        callback = function()
            vim.opt_local.tabstop = 4
            vim.opt_local.shiftwidth = 4
            vim.opt_local.softtabstop = 4
            vim.opt_local.expandtab = true
            vim.opt_local.foldmethod = "indent"
            vim.opt_local.foldenable = true
            vim.opt_local.foldcolumn = "4"
            vim.opt_local.foldlevel = 99
            vim.opt_local.foldminlines = 1
        end
    })

    -- LaTeX
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "tex",
        callback = function()
            vim.opt_local.textwidth = 80
            vim.opt_local.wrap = true
            vim.opt_local.linebreak = true
            vim.opt_local.foldmethod = "indent"
            vim.opt_local.foldenable = true
            vim.opt_local.foldcolumn = "4"
            vim.opt_local.foldlevel = 99
            vim.opt_local.foldminlines = 1
        end
    })

    -- Lua
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "lua",
        callback = function()
            vim.opt_local.foldmethod = "indent"
            vim.opt_local.foldenable = true
            vim.opt_local.foldcolumn = "4"
            vim.opt_local.foldlevel = 99
            vim.opt_local.foldminlines = 1
        end
    })

    -- Shell scripts
    vim.api.nvim_create_autocmd("FileType", {
        pattern = { "sh", "bash", "zsh" },
        callback = function()
            vim.opt_local.foldmethod = "indent"
            vim.opt_local.foldenable = true
            vim.opt_local.foldcolumn = "4"
            vim.opt_local.foldlevel = 99
            vim.opt_local.foldminlines = 1
        end
    })

    -- JSON/YAML/TOML
    vim.api.nvim_create_autocmd("FileType", {
        pattern = { "json", "yaml", "toml" },
        callback = function()
            vim.opt_local.foldmethod = "indent"
            vim.opt_local.foldenable = true
            vim.opt_local.foldcolumn = "4"
            vim.opt_local.foldlevel = 99
            vim.opt_local.foldminlines = 1
        end
    })

    -- Markdown and other text files
    vim.api.nvim_create_autocmd("FileType", {
        pattern = { "markdown", "md", "txt", "text" },
        callback = function()
            vim.opt_local.foldmethod = "indent"
            vim.opt_local.foldenable = true
            vim.opt_local.foldcolumn = "4"
            vim.opt_local.foldlevel = 99
            vim.opt_local.foldminlines = 1
        end
    })
end

-- Language-specific keybindings
local function setup_language_keybindings()
    -- Python
    keymap('n', '<leader>yr', ':!python %<CR>', { desc = 'Run Python file' })
    keymap('n', '<leader>yt', ':!python -m pytest %<CR>', { desc = 'Run Python tests' })

    -- Go
    keymap('n', '<leader>yr', ':!go run %<CR>', { desc = 'Run Go file' })
    keymap('n', '<leader>yt', ':!go test %<CR>', { desc = 'Run Go tests' })

    -- Rust
    keymap('n', '<leader>yr', ':!cargo run<CR>', { desc = 'Run Rust project' })
    keymap('n', '<leader>yt', ':!cargo test<CR>', { desc = 'Run Rust tests' })

    -- JavaScript/TypeScript
    keymap('n', '<leader>yr', ':!node %<CR>', { desc = 'Run JavaScript file' })
    keymap('n', '<leader>yt', ':!npm test<CR>', { desc = 'Run JavaScript tests' })

    -- LaTeX
    keymap('n', '<leader>yb', ':!latexmk -pdf %<CR>', { desc = 'Build LaTeX document' })
    keymap('n', '<leader>yv', ':!zathura %:r.pdf &<CR>', { desc = 'View LaTeX PDF' })

    -- Docker
    keymap('n', '<leader>yd', ':!docker build .<CR>', { desc = 'Build Docker image' })
    keymap('n', '<leader>yr', ':!docker run<CR>', { desc = 'Run Docker container' })

    -- Git (removed as they conflict with fugitive)
    -- keymap('n', '<leader>gs', ':G<CR>', { desc = 'Git status' })
    -- keymap('n', '<leader>gc', ':Git commit<CR>', { desc = 'Git commit' })
    -- keymap('n', '<leader>gp', ':Git push<CR>', { desc = 'Git push' })
end

-- Initialize
setup_language_settings()
setup_language_keybindings()

