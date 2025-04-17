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
            vim.opt_local.textwidth = 88  -- Black formatter default
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
        end
    })

    -- LaTeX
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "tex",
        callback = function()
            vim.opt_local.textwidth = 80
            vim.opt_local.wrap = true
            vim.opt_local.linebreak = true
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