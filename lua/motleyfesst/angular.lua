local M = {}

M.setup = function()
    local lspconfig = require("lspconfig")
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    -- Angular Language Server
    lspconfig.angularls.setup({
        capabilities = capabilities,
        on_attach = function(client, bufnr)
            -- Enable formatting on save
            vim.api.nvim_create_autocmd("BufWritePre", {
                buffer = bufnr,
                callback = function()
                    vim.lsp.buf.format()
                end,
            })
        end,
        filetypes = { "typescript", "html", "typescriptreact", "typescript.tsx" },
        root_dir = lspconfig.util.root_pattern("angular.json", "package.json"),
    })

    -- ESLint
    lspconfig.eslint.setup({
        capabilities = capabilities,
        on_attach = function(client, bufnr)
            vim.api.nvim_create_autocmd("BufWritePre", {
                buffer = bufnr,
                command = "EslintFixAll",
            })
        end,
    })

    -- Prettier
    local null_ls = require("null-ls")
    null_ls.setup({
        sources = {
            null_ls.builtins.formatting.prettier.with({
                filetypes = { "typescript", "javascript", "html", "json" },
            }),
        },
    })
end

return M
