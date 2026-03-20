local M = {}

local LOG_TAG = "[fold_utils]"

local function log_debug(msg)
    vim.schedule(function()
        vim.notify(LOG_TAG .. " " .. msg, vim.log.levels.DEBUG)
    end)
end

local function apply_base_opts()
    vim.opt_local.foldenable = true
    vim.opt_local.foldcolumn = "4"
    vim.opt_local.foldlevel = 99
    vim.opt_local.foldminlines = 1
    vim.opt_local.foldnestmax = 20
end

function M.setup_treesitter()
    if not vim.treesitter or not vim.treesitter.foldexpr then
        log_debug("vim.treesitter.foldexpr not available, skipping treesitter folding")
        return
    end
    apply_base_opts()
    vim.opt_local.foldmethod = "expr"
    vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
end

function M.setup_lsp()
    if not vim.lsp or not vim.lsp.foldexpr then
        log_debug("vim.lsp.foldexpr not available, falling back to treesitter")
        M.setup_treesitter()
        return
    end
    apply_base_opts()
    vim.opt_local.foldmethod = "expr"
    vim.opt_local.foldexpr = "v:lua.vim.lsp.foldexpr()"
end

function M.setup_indent()
    apply_base_opts()
    vim.opt_local.foldmethod = "indent"
    vim.opt_local.foldexpr = ""
end

M.INDENT_FILETYPES = {
    python = true,
    sh = true,
    bash = true,
    zsh = true,
}

---@param client vim.lsp.Client
---@param bufnr number
function M.on_lsp_attach(client, bufnr)
    if not client then
        log_debug("on_lsp_attach called with nil client")
        return
    end
    local ft = vim.bo[bufnr].filetype
    if M.INDENT_FILETYPES[ft] then
        log_debug("skipping LSP folding for indent filetype: " .. ft)
        return
    end
    local caps = client.server_capabilities
    if not caps then
        log_debug(client.name .. ": nil server_capabilities, skipping folding")
        return
    end
    if not caps.foldingRangeProvider then
        log_debug(client.name .. ": no foldingRangeProvider, keeping treesitter folding")
        return
    end
    vim.schedule(function()
        if not vim.api.nvim_buf_is_valid(bufnr) then
            log_debug("buf " .. bufnr .. " invalid by the time LSP folding scheduled")
            return
        end
        vim.api.nvim_buf_call(bufnr, function()
            M.setup_lsp()
        end)
    end)
end

return M
