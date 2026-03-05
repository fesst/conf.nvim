local M = {}

local LOG_TAG = "[lsp_utils]"

local function format_buffer(bufnr)
    local ok_conform, conform = pcall(require, "conform")
    if ok_conform then
        conform.format({ bufnr = bufnr, timeout_ms = 3000, lsp_format = "fallback" })
    else
        vim.notify(LOG_TAG .. " conform not available, using vim.lsp.buf.format", vim.log.levels.DEBUG)
        vim.lsp.buf.format({ async = false, bufnr = bufnr })
    end
end

function M.make_capabilities()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.workspace = {
        configuration = true,
    }
    capabilities.textDocument = {
        completion = {
            completionItem = {
                snippetSupport = true,
            },
        },
    }

    -- blink.cmp capabilities (old nvim-cmp in after/discharged/completion/)
    local ok_blink, blink = pcall(require, "blink.cmp")
    if ok_blink then
        capabilities = blink.get_lsp_capabilities(capabilities)
    end

    return capabilities
end

function M.attach_default_keymaps(bufnr)
    local opts = { buffer = bufnr, silent = true }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>f", function()
        format_buffer(bufnr)
    end, opts)
    vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
    vim.keymap.set("n", "[i", vim.diagnostic.goto_prev, opts)
    vim.keymap.set("n", "]i", vim.diagnostic.goto_next, opts)
end

-- format_on_save is now handled by conform.nvim (after/plugin/lsp/conform.lua)
-- This function is kept for LSPs that need custom filter logic (e.g. jdtls)
function M.setup_format_on_save(bufnr, filter)
    -- conform handles format_on_save globally; skip per-buffer LSP setup
    -- unless a custom filter is provided
    if not filter then
        return
    end
    local format_group = vim.api.nvim_create_augroup("LspFormatOnSave", { clear = false })
    vim.api.nvim_clear_autocmds({ group = format_group, buffer = bufnr })
    vim.api.nvim_create_autocmd("BufWritePre", {
        group = format_group,
        buffer = bufnr,
        callback = function()
            vim.lsp.buf.format({ async = false, bufnr = bufnr, filter = filter })
        end,
    })
end

function M.default_on_attach(client, bufnr)
    M.setup_format_on_save(bufnr)
    M.attach_default_keymaps(bufnr)
    require("motleyfesst.fold_utils").on_lsp_attach(client, bufnr)
end

return M
