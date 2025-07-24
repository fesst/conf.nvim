require("motleyfesst.utils")

if IS_NOT_SSH() then
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
            "angularls", "ts_ls", "eslint", "html", "cssls", "jsonls", "yamlls", "dockerls", "taplo", "pyright", "gopls", "omnisharp", "jdtls", "kotlin_language_server", "clangd", "rust_analyzer", "elixirls", "zls", "sqlls", "gradle_ls", "bashls", "lua_ls", "awk_ls", "texlab", "lemminx",
        },
        automatic_installation = true,
        handlers = {
            function(server_name)
                local lspconfig = require("lspconfig")
                if server_name == "gradle_ls" then
                    lspconfig.gradle_ls.setup({
                        init_options = {
                            settings = {
                                gradle = {
                                    wrapperEnabled = true,
                                    wrapperPath = "gradle/wrapper/gradle-wrapper.jar",
                                },
                            },
                        },
                        settings = {
                            gradle = {
                                wrapperEnabled = true,
                                wrapperPath = "gradle/wrapper/gradle-wrapper.jar",
                            },
                        },
                        filetypes = { "groovy", "java", "kotlin" },
                        root_dir = lspconfig.util.root_pattern(
                            "build.gradle",
                            "build.gradle.kts",
                            "settings.gradle",
                            "settings.gradle.kts"
                        ),
                    })
                else
                    lspconfig[server_name].setup({})
                end
            end,
        },
    })

    vim.api.nvim_create_autocmd("FileType", {
        pattern = { "text", "txt", "markdown", "md" },
        callback = function()
            -- Prevent LSP from attaching to text files
            vim.api.nvim_buf_set_option(0, "omnifunc", "")
            local clients = vim.lsp.get_clients()
            for _, client in ipairs(clients) do
                if client.name == "textlsp" then
                    vim.lsp.stop_client(client.id)
                end
            end
        end,
    })
    vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = false,
    })

    vim.api.nvim_create_autocmd("BufReadPost", {
        pattern = { "*.txt", "*.text", "*.md", "*.markdown" },
        callback = function()
            vim.diagnostic.hide()
        end,
    })

    require("render-markdown").setup({})

    require("mason-lspconfig").setup({

    })

    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    local lspconfig = require("lspconfig")

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

    local configs = {
        angularls = {
            capabilities = capabilities,
            on_attach = on_attach,
            filetypes = { "typescript", "html", "typescriptreact", "typescript.tsx" },
            root_dir = lspconfig.util.root_pattern("angular.json", "package.json"),
        },
        ts_ls = {
            capabilities = capabilities,
            on_attach = function(client, bufnr)
                vim.api.nvim_create_autocmd("BufWritePre", {
                    buffer = bufnr,
                    callback = function()
                        vim.lsp.buf.format({ async = false })
                    end,
                })

                vim.opt_local.foldmethod = "expr"
                vim.opt_local.foldexpr = "v:lua.vim.lsp.foldexpr()"
                vim.opt_local.foldenable = true
                vim.opt_local.foldcolumn = "4"
                vim.opt_local.foldlevel = 99
                vim.opt_local.foldminlines = 1

                local opts = { buffer = bufnr, silent = true }
                vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
                vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
                vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
                vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, opts)
                vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
                vim.keymap.set("n", "[i", vim.diagnostic.goto_prev, opts)
                vim.keymap.set("n", "]i", vim.diagnostic.goto_next, opts)
            end,
            filetypes = { "typescript", "javascript", "typescriptreact", "typescript.tsx" },
            root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json"),
            settings = {
                typescript = {
                    folding = true,
                },
                javascript = {
                    folding = true,
                },
            },
        },
        eslint = {
            capabilities = capabilities,
            on_attach = on_attach,
            filetypes = { "typescript", "javascript", "typescriptreact", "typescript.tsx" },
        },
        html = {
            capabilities = capabilities,
            on_attach = function(client, bufnr)
                vim.api.nvim_create_autocmd("BufWritePre", {
                    buffer = bufnr,
                    callback = function()
                        vim.lsp.buf.format({ async = false })
                    end,
                })

                vim.opt_local.foldmethod = "expr"
                vim.opt_local.foldexpr = "v:lua.vim.lsp.foldexpr()"
                vim.opt_local.foldenable = true
                vim.opt_local.foldcolumn = "4"
                vim.opt_local.foldlevel = 99
                vim.opt_local.foldminlines = 1

                local opts = { buffer = bufnr, silent = true }
                vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
                vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
                vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
                vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, opts)
                vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
                vim.keymap.set("n", "[i", vim.diagnostic.goto_prev, opts)
                vim.keymap.set("n", "]i", vim.diagnostic.goto_next, opts)
            end,
            filetypes = { "html", "htmldjango" },
            settings = {
                html = {
                    folding = true,
                },
            },
        },
        cssls = {
            capabilities = capabilities,
            on_attach = function(client, bufnr)
                vim.api.nvim_create_autocmd("BufWritePre", {
                    buffer = bufnr,
                    callback = function()
                        vim.lsp.buf.format({ async = false })
                    end,
                })

                vim.opt_local.foldmethod = "expr"
                vim.opt_local.foldexpr = "v:lua.vim.lsp.foldexpr()"
                vim.opt_local.foldenable = true
                vim.opt_local.foldcolumn = "4"
                vim.opt_local.foldlevel = 99
                vim.opt_local.foldminlines = 1

                local opts = { buffer = bufnr, silent = true }
                vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
                vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
                vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
                vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, opts)
                vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
                vim.keymap.set("n", "[i", vim.diagnostic.goto_prev, opts)
                vim.keymap.set("n", "]i", vim.diagnostic.goto_next, opts)
            end,
            filetypes = { "css", "scss", "less" },
            settings = {
                css = {
                    folding = true,
                },
            },
        },
        jsonls = {
            capabilities = capabilities,
            on_attach = function(client, bufnr)
                vim.api.nvim_create_autocmd("BufWritePre", {
                    buffer = bufnr,
                    callback = function()
                        vim.lsp.buf.format({ async = false })
                    end,
                })

                vim.opt_local.foldmethod = "expr"
                vim.opt_local.foldexpr = "v:lua.vim.lsp.foldexpr()"
                vim.opt_local.foldenable = true
                vim.opt_local.foldcolumn = "4"
                vim.opt_local.foldlevel = 99
                vim.opt_local.foldminlines = 1

                local opts = { buffer = bufnr, silent = true }
                vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
                vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
                vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
                vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, opts)
                vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
                vim.keymap.set("n", "[i", vim.diagnostic.goto_prev, opts)
                vim.keymap.set("n", "]i", vim.diagnostic.goto_next, opts)
            end,
            settings = {
                json = {
                    schemas = require("schemastore").json.schemas(),
                    validate = { enable = true },
                    folding = true,
                },
            },
        },
        yamlls = {
            capabilities = capabilities,
            on_attach = on_attach,
            settings = {
                yaml = {
                    schemas = require("schemastore").yaml.schemas(),
                },
            },
        },
        dockerls = {
            capabilities = capabilities,
            on_attach = on_attach,
        },

        pyright = {
            capabilities = capabilities,
            on_attach = function(client, bufnr)
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
            end,
            settings = {
                python = {
                    analysis = {
                        typeCheckingMode = "basic",
                        diagnosticMode = "workspace",
                        useLibraryCodeForTypes = true,
                    },
                },
            },
        },
        gopls = {
            capabilities = capabilities,
            on_attach = on_attach,
            settings = {
                gopls = {
                    analyses = {
                        unusedparams = true,
                    },
                    staticcheck = true,
                },
            },
        },
        omnisharp = {
            capabilities = capabilities,
            on_attach = on_attach,
            cmd = { "omnisharp", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
            settings = {
                omnisharp = {
                    enableRoslynAnalyzers = true,
                    organizeImportsOnFormat = true,
                    enableEditorConfigSupport = true,
                    enableImportCompletion = true,
                },
            },
        },
        jdtls = {
            capabilities = capabilities,
            on_attach = on_attach,
        },
        kotlin_language_server = {
            capabilities = capabilities,
            on_attach = on_attach,
        },
        clangd = {
            capabilities = capabilities,
            on_attach = function(client, bufnr)
                vim.api.nvim_create_autocmd("BufWritePre", {
                    buffer = bufnr,
                    callback = function()
                        vim.lsp.buf.format({ async = false })
                    end,
                })

                vim.opt_local.foldmethod = "expr"
                vim.opt_local.foldexpr = "v:lua.vim.lsp.foldexpr()"
                vim.opt_local.foldenable = true
                vim.opt_local.foldcolumn = "4"
                vim.opt_local.foldlevel = 99
                vim.opt_local.foldminlines = 1

                local opts = { buffer = bufnr, silent = true }
                vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
                vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
                vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
                vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, opts)
                vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
                vim.keymap.set("n", "[i", vim.diagnostic.goto_prev, opts)
                vim.keymap.set("n", "]i", vim.diagnostic.goto_next, opts)
            end,
            cmd = {
                "clangd",
                "--background-index",
                "--suggest-missing-includes",
                "--clang-tidy",
                "--header-insertion=iwyu",
            },
            settings = {
                clangd = {
                    folding = true,
                },
            },
        },
        rust_analyzer = {
            capabilities = capabilities,
            on_attach = on_attach,
            settings = {
                ["rust-analyzer"] = {
                    checkOnSave = true,
                    diagnostics = {
                        enable = true,
                    },
                    cargo = {
                        allFeatures = true,
                    },
                },
            },
        },
        elixirls = {
            capabilities = capabilities,
            on_attach = on_attach,
            settings = {
                elixirLS = {
                    dialyzerEnabled = true,
                },
            },
        },
        zls = {
            capabilities = capabilities,
            on_attach = on_attach,
        },

        bashls = {
            capabilities = capabilities,
            on_attach = on_attach,
            filetypes = { "sh", "zsh", "bash" },
        },
        lua_ls = {
            capabilities = capabilities,
            on_attach = on_attach,
            settings = {
                Lua = {
                    runtime = {
                        version = "LuaJIT",
                    },
                    diagnostics = {
                        globals = { "vim" },
                    },
                    workspace = {
                        library = vim.api.nvim_get_runtime_file("", true),
                    },
                    telemetry = {
                        enable = false,
                    },
                    folding = true,
                },
            },
        },
        awk_ls = {
            capabilities = capabilities,
            on_attach = on_attach,
        },

        texlab = {
            capabilities = capabilities,
            on_attach = on_attach,
        },
        lemminx = {
            capabilities = capabilities,
            on_attach = on_attach,
        },
        taplo = {
            capabilities = capabilities,
            on_attach = on_attach,
            settings = {
                taplo = {
                    formatter = {
                        alignEntries = true,
                        alignComments = true,
                        compactArrays = true,
                        compactInlineTables = true,
                    },
                },
            },
        },

        sqlls = {
            capabilities = capabilities,
            on_attach = on_attach,
            settings = {
                sqlLanguageServer = {
                    connections = {
                        {
                            name = "PostgreSQL Dev",
                            adapter = "postgresql",
                            host = "localhost",
                            port = 5432,
                            database = "dev_db",
                            user = "dev_user",
                            password = "", -- Set this in your environment or use .pgpass
                        },
                        -- Production database (commented out for safety)
                        -- {
                        --     name = "PostgreSQL Prod",
                        --     adapter = "postgresql",
                        --     host = "prod.example.com",
                        --     port = 5432,
                        --     database = "prod_db",
                        --     user = "prod_user",
                        --     password = "", -- Set this in your environment or use .pgpass
                        -- },
                        -- Test database
                        {
                            name = "PostgreSQL Test",
                            adapter = "postgresql",
                            host = "localhost",
                            port = 5432,
                            database = "test_db",
                            user = "test_user",
                            password = "", -- Set this in your environment or use .pgpass
                        },
                    },
                    format = {
                        language = "postgresql",
                        uppercase = true,
                        linesBetweenQueries = 2,
                        keywordCase = "upper", -- Options: "upper", "lower", "capitalize"
                        identifierCase = "lower", -- Options: "upper", "lower", "capitalize"
                        dataTypeCase = "upper", -- Options: "upper", "lower", "capitalize"
                        functionCase = "lower", -- Options: "upper", "lower", "capitalize"
                        indentStyle = "standard", -- Options: "standard", "tabularLeft", "tabularRight"
                        maxLineLength = 100,
                        commaStyle = "end", -- Options: "end", "start"
                        logicalOperatorNewLine = "before", -- Options: "before", "after"
                    },
                    lint = {
                        enable = true,
                        dialect = "postgresql",
                        rules = {
                            ["keyword-case"] = "error",
                            ["identifier-case"] = "warning",
                            ["quoted-identifier-case"] = "off",
                            ["function-case"] = "warning",
                            ["data-type-case"] = "error",
                            ["table-name-case"] = "warning",
                            ["column-name-case"] = "warning",
                            ["schema-name-case"] = "warning",
                            ["view-name-case"] = "warning",
                            ["materialized-view-name-case"] = "warning",
                            ["function-name-case"] = "warning",
                            ["procedure-name-case"] = "warning",
                            ["trigger-name-case"] = "warning",
                            ["index-name-case"] = "warning",
                            ["constraint-name-case"] = "warning",
                            ["sequence-name-case"] = "warning",
                            ["type-name-case"] = "warning",
                            ["domain-name-case"] = "warning",
                        },
                    },
                    completion = {
                        enable = true,
                        showTables = true,
                        showViews = true,
                        showFunctions = true,
                        showProcedures = true,
                        showTriggers = true,
                        showIndexes = true,
                        showConstraints = true,
                        showSequences = true,
                        showTypes = true,
                        showDomains = true,
                    },
                },
            },
        },
    }

    for server_name, config in pairs(configs) do
        lspconfig[server_name].setup(config)
    end

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
end
