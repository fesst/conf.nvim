local ssh_utils = require("motleyfesst.ssh_utils")

if ssh_utils.IS_LOCAL() then
    local lsp_utils = require("motleyfesst.lsp_utils")
    require("mason").setup({
        ui = {
            icons = {
                package_installed = "✓",
                package_pending = "➜",
                package_uninstalled = "✗",
            },
        },
    })
    require("mason-lspconfig").setup({
        ensure_installed = {
            "bashls",
            "cssls",
            "dockerls",
            "eslint",
            "graphql",
            "html",
            "starpls",
            "bazelrc_lsp",
            "jdtls",
            "jsonls",
            "kotlin_language_server",
            "lua_ls",
            "pyright",
            "ts_ls",
            "yamlls",
            -- "clangd", "awk_ls", "texlab", "lemminx"
        },
        automatic_installation = false,
    })
    local capabilities = lsp_utils.make_capabilities()
    local on_attach = lsp_utils.default_on_attach

    vim.lsp.config("angularls", {
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { "typescript", "html", "typescriptreact", "typescript.tsx" },
    })
    vim.lsp.enable("angularls")
    -- TypeScript/JavaScript
    vim.lsp.config("ts_ls", {
        capabilities = capabilities,
        on_attach = function(client, bufnr)
            on_attach(client, bufnr)
            vim.opt_local.foldmethod = "expr"
            vim.opt_local.foldexpr = "v:lua.vim.lsp.foldexpr()"
            vim.opt_local.foldenable = true
            vim.opt_local.foldcolumn = "4"
            vim.opt_local.foldlevel = 99
            vim.opt_local.foldminlines = 1
        end,
        filetypes = { "typescript", "javascript", "typescriptreact", "typescript.tsx" },
        settings = {
            typescript = { folding = true },
            javascript = { folding = true },
        },
    })
    vim.lsp.enable("ts_ls")
    -- ESLintformat
    vim.lsp.config("eslint", {
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { "typescript", "javascript", "typescriptreact", "typescript.tsx" },
    })
    vim.lsp.enable("eslint")
    vim.lsp.config("html", {
        capabilities = capabilities,
        on_attach = function(client, bufnr)
            on_attach(client, bufnr)
            vim.opt_local.foldmethod = "expr"
            vim.opt_local.foldexpr = "v:lua.vim.lsp.foldexpr()"
            vim.opt_local.foldenable = true
            vim.opt_local.foldcolumn = "4"
            vim.opt_local.foldlevel = 99
            vim.opt_local.foldminlines = 1
        end,
        filetypes = { "html", "htmldjango" },
        settings = {
            html = { folding = true },
        },
    })
    vim.lsp.enable("html")

    vim.lsp.config("cssls", {
        capabilities = capabilities,
        on_attach = function(client, bufnr)
            on_attach(client, bufnr)
            vim.opt_local.foldmethod = "expr"
            vim.opt_local.foldexpr = "v:lua.vim.lsp.foldexpr()"
            vim.opt_local.foldenable = true
            vim.opt_local.foldcolumn = "4"
            vim.opt_local.foldlevel = 99
            vim.opt_local.foldminlines = 1
        end,
        filetypes = { "css", "scss", "less" },
        settings = {
            css = { folding = true },
        },
    })
    vim.lsp.enable("cssls")

    vim.lsp.config("jsonls", {
        capabilities = capabilities,
        on_attach = function(client, bufnr)
            on_attach(client, bufnr)
            vim.opt_local.foldmethod = "expr"
            vim.opt_local.foldexpr = "v:lua.vim.lsp.foldexpr()"
            vim.opt_local.foldenable = true
            vim.opt_local.foldcolumn = "4"
            vim.opt_local.foldlevel = 99
            vim.opt_local.foldminlines = 1
        end,
        settings = {
            json = {
                schemas = require("schemastore").json.schemas(),
                validate = { enable = true },
                folding = true,
            },
        },
    })
    vim.lsp.enable("jsonls")

    vim.lsp.config("yamlls", {
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
            yaml = {
                schemas = require("schemastore").yaml.schemas(),
            },
        },
    })
    vim.lsp.enable("yamlls")

    vim.lsp.config("kotlin_language_server", {
        capabilities = capabilities,
        on_attach = on_attach,
    })
    vim.lsp.enable("kotlin_language_server")
    -- Bash
    vim.lsp.config("bashls", {
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { "sh", "zsh", "bash" },
        settings = {
            bashls = { folding = true, shiftwidth = 4 },
            zsh = { folding = true, shiftwidth = 4 },
            sh = { folding = true, shiftwidth = 4 },
        },
    })
    vim.lsp.enable("bashls")

    vim.lsp.config("lua_ls", {
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
            Lua = {
                runtime = { version = "LuaJIT" },
                diagnostics = { globals = { "vim" } },
                workspace = { library = vim.api.nvim_get_runtime_file("", true) },
                telemetry = { enable = false },
                folding = true,
            },
        },
    })
    vim.lsp.enable("lua_ls")

    vim.lsp.config("awk_ls", {
        capabilities = capabilities,
        on_attach = on_attach,
    })
    vim.lsp.enable("awk_ls")

    vim.lsp.config("texlab", {
        capabilities = capabilities,
        on_attach = on_attach,
    })
    vim.lsp.enable("texlab")

    vim.lsp.config("lemminx", {
        capabilities = capabilities,
        on_attach = on_attach,
    })
    vim.lsp.enable("lemminx")

    vim.lsp.config("dockerls", {
        capabilities = capabilities,
        on_attach = on_attach,
    })
    vim.lsp.enable("dockerls")

    vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = false,
    })

    local border = {
        { "╭", "FloatBorder" },
        { "─", "FloatBorder" },
        { "╮", "FloatBorder" },
        { "│", "FloatBorder" },
        { "╯", "FloatBorder" },
        { "─", "FloatBorder" },
        { "╰", "FloatBorder" },
        { "│", "FloatBorder" },
    }

    local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
    function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
        opts = opts or {}
        opts.border = opts.border or border
        return orig_util_open_floating_preview(contents, syntax, opts, ...)
    end

    -- -- Prevent LSP from attaching to text files
    -- vim.api.nvim_create_autocmd("FileType", {
    --     pattern = { "text", "txt", "markdown", "md" },
    --     callback = function()
    --         vim.api.nvim_buf_set_option(0, "omnifunc", "")
    --         local clients = vim.lsp.get_clients()
    --         for _, client in ipairs(clients) do
    --             if client.name == "textlsp" then
    --                 vim.lsp.stop_client(client.id)
    --             end
    --         end
    --     end,
    -- })

    vim.api.nvim_create_autocmd("BufReadPost", {
        pattern = { "*.txt", "*.text", "*.md", "*.markdown" },
        callback = function()
            vim.diagnostic.hide()
        end,
    })

    require("render-markdown").setup({})
end
