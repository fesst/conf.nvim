local null_ls = require("null-ls")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics
local code_actions = null_ls.builtins.code_actions

-- Ensure null-ls is properly initialized
null_ls.setup({
    sources = {
        -- Formatting
        formatting.stylua,
        formatting.prettier,
        formatting.black,
        formatting.isort,
        
        -- Diagnostics
        diagnostics.eslint_d,
        diagnostics.flake8,
        
        -- Code Actions
        code_actions.eslint_d,
        code_actions.gitsigns,
    },
    -- Remove capabilities from here as it's handled by the LSP client
    on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
            vim.api.nvim_create_autocmd("BufWritePre", {
                buffer = bufnr,
                callback = function()
                    vim.lsp.buf.format({ async = false })
                end,
            })
        end
    end,
}) 