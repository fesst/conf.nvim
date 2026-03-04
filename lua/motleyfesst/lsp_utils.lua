local M = {}

local format_group = vim.api.nvim_create_augroup("LspFormatOnSave", { clear = false })

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

    local ok_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
    if ok_cmp then
        capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
    end

    return capabilities
end

function M.attach_default_keymaps(bufnr)
    local opts = { buffer = bufnr, silent = true }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, opts)
    vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
    vim.keymap.set("n", "[i", vim.diagnostic.goto_prev, opts)
    vim.keymap.set("n", "]i", vim.diagnostic.goto_next, opts)
end

function M.setup_format_on_save(bufnr, filter)
    vim.api.nvim_clear_autocmds({ group = format_group, buffer = bufnr })
    vim.api.nvim_create_autocmd("BufWritePre", {
        group = format_group,
        buffer = bufnr,
        callback = function()
            local opts = { async = false, bufnr = bufnr }
            if filter then
                opts.filter = filter
            end
            vim.lsp.buf.format(opts)
        end,
    })
end

function M.default_on_attach(_, bufnr)
    M.setup_format_on_save(bufnr)
    M.attach_default_keymaps(bufnr)
end

return M
