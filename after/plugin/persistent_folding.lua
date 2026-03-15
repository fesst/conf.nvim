local function setup_persistent_folding()
    local view_dir = vim.fn.stdpath("data") .. "/view"
    if vim.fn.isdirectory(view_dir) == 0 then
        vim.fn.mkdir(view_dir, "p")
    end
    vim.opt.viewdir = view_dir
end

-- Filetypes to skip persistent folding (usually temporary buffers, LSP diagnostics, etc)
local SKIP_FILETYPES = {
    [""] = true,                   -- no filetype
    qf = true,                     -- quickfix
    fugitive = true,               -- vim-fugitive
    fugitiveblame = true,          -- git blame
    help = true,                   -- help pages
    terminal = true,               -- terminal buffers
    gitcommit = true,              -- git commit message
    fzf = true,                    -- fzf floating window
    lspinfo = true,                -- lsp info panel
    TelescopePrompt = true,        -- telescope prompt
    DressingInput = true,          -- dressing input
    ["dap-repl"] = true,           -- DAP REPL
}

setup_persistent_folding()

vim.keymap.set("n", "<leader>vs", ":silent! mkview<CR>", { desc = "Save view (folding state)" })
vim.keymap.set("n", "<leader>vl", ":silent! loadview<CR>", { desc = "Load view (folding state)" })
vim.keymap.set("n", "<leader>vr", ":silent! loadview!<CR>", { desc = "Load view (force)" })

local persistent_folding_group = vim.api.nvim_create_augroup("PersistentFolding", { clear = true })

local function should_manage_view(bufnr)
    if not vim.api.nvim_buf_is_valid(bufnr) then
        return false
    end

    local buf_opts = vim.bo[bufnr]
    return buf_opts.buftype == "" and not SKIP_FILETYPES[buf_opts.filetype]
end

local function save_view(bufnr)
    if should_manage_view(bufnr) and vim.api.nvim_get_current_buf() == bufnr then
        pcall(vim.cmd, "silent! mkview")
    end
end

local function load_view(bufnr)
    if should_manage_view(bufnr) and vim.api.nvim_get_current_buf() == bufnr then
        pcall(vim.cmd, "silent! loadview")
    end
end

vim.api.nvim_create_autocmd("BufLeave", {
    pattern = "*",
    callback = function(args)
        if should_manage_view(args.buf) then
            save_view(args.buf)
        end
    end,
    group = persistent_folding_group,
})

vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*",
    callback = function(args)
        load_view(args.buf)
    end,
    group = persistent_folding_group,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function(args)
        local bufnr = args.buf
        if not should_manage_view(bufnr) then
            return
        end

        -- Defer to ensure filetype is fully settled and folding is set up.
        vim.defer_fn(function()
            if vim.api.nvim_get_current_buf() ~= bufnr then
                return
            end
            load_view(bufnr)
        end, 10)
    end,
    group = persistent_folding_group,
})

vim.api.nvim_create_autocmd("WinLeave", {
    pattern = "*",
    callback = function(args)
        if should_manage_view(args.buf) then
            save_view(args.buf)
        end
    end,
    group = persistent_folding_group,
})

