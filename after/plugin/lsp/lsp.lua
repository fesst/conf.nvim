local ssh_utils = require("motleyfesst.ssh_utils")

if ssh_utils.IS_MAC() then
    require("mason").setup({
        ui = {
            icons = {
                package_installed = "✓",
                package_pending = "➜",
                package_uninstalled = "✗",
            },
        }
    })
    
    require("mason-lspconfig").setup({
        ensure_installed = {
            "angularls", "ts_ls", "eslint", "html", "cssls", "jsonls", "yamlls", "jdtls", 
            "kotlin_language_server", "bashls", "lua_ls", "awk_ls", "texlab", "lemminx", 
            "pyright", "dockerls", "clangd"
        },
        automatic_installation = true,
    })

    -- Global capabilities
    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    
    -- Global on_attach function
    local on_attach = function(client, bufnr)
        vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.format({ async = false })
            end,
        })

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

    -- Configure LSP servers using new vim.lsp.config API
    -- Angular
    vim.lsp.config('angularls', {
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { "typescript", "html", "typescriptreact", "typescript.tsx" },
    })
    vim.lsp.enable('angularls')

    -- TypeScript/JavaScript
    vim.lsp.config('ts_ls', {
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
    vim.lsp.enable('ts_ls')

    -- ESLint
    vim.lsp.config('eslint', {
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { "typescript", "javascript", "typescriptreact", "typescript.tsx" },
    })
    vim.lsp.enable('eslint')

    -- HTML
    vim.lsp.config('html', {
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
    vim.lsp.enable('html')

    -- CSS
    vim.lsp.config('cssls', {
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
    vim.lsp.enable('cssls')

    -- JSON
    vim.lsp.config('jsonls', {
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
    vim.lsp.enable('jsonls')

    -- YAML
    vim.lsp.config('yamlls', {
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
            yaml = {
                schemas = require("schemastore").yaml.schemas(),
            },
        },
    })
    vim.lsp.enable('yamlls')

    -- Python
    vim.lsp.config('pyright', {
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
            python = {
                analysis = {
                    typeCheckingMode = "basic",
                    diagnosticMode = "workspace",
                    useLibraryCodeForTypes = true,
                },
            },
        },
    })
    vim.lsp.enable('pyright')

    -- Java
    vim.lsp.config('jdtls', {
        capabilities = capabilities,
        on_attach = on_attach,
    })
    vim.lsp.enable('jdtls')

    -- Kotlin
    vim.lsp.config('kotlin_language_server', {
        capabilities = capabilities,
        on_attach = on_attach,
    })
    vim.lsp.enable('kotlin_language_server')

    -- C/C++
    vim.lsp.config('clangd', {
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
        cmd = {
            "clangd",
            "--background-index",
            "--suggest-missing-includes",
            "--clang-tidy",
            "--header-insertion=iwyu",
        },
        settings = {
            clangd = { folding = true },
        },
    })
    vim.lsp.enable('clangd')

    -- Bash
    vim.lsp.config('bashls', {
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { "sh", "zsh", "bash" },
    })
    vim.lsp.enable('bashls')

    -- Lua
    vim.lsp.config('lua_ls', {
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
    vim.lsp.enable('lua_ls')

    -- AWK
    vim.lsp.config('awk_ls', {
        capabilities = capabilities,
        on_attach = on_attach,
    })
    vim.lsp.enable('awk_ls')

    -- LaTeX
    vim.lsp.config('texlab', {
        capabilities = capabilities,
        on_attach = on_attach,
    })
    vim.lsp.enable('texlab')

    -- XML
    vim.lsp.config('lemminx', {
        capabilities = capabilities,
        on_attach = on_attach,
    })
    vim.lsp.enable('lemminx')

    -- Docker
    vim.lsp.config('dockerls', {
        capabilities = capabilities,
        on_attach = on_attach,
    })
    vim.lsp.enable('dockerls')

    -- Configure diagnostics
    vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = false,
    })

    -- Configure floating preview borders
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

    -- Prevent LSP from attaching to text files
    vim.api.nvim_create_autocmd("FileType", {
        pattern = { "text", "txt", "markdown", "md" },
        callback = function()
            vim.api.nvim_buf_set_option(0, "omnifunc", "")
            local clients = vim.lsp.get_clients()
            for _, client in ipairs(clients) do
                if client.name == "textlsp" then
                    vim.lsp.stop_client(client.id)
                end
            end
        end,
    })

    vim.api.nvim_create_autocmd("BufReadPost", {
        pattern = { "*.txt", "*.text", "*.md", "*.markdown" },
        callback = function()
            vim.diagnostic.hide()
        end,
    })

    require("render-markdown").setup({})
end
