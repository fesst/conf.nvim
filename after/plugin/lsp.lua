-- Mason configuration
require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = {
        "gradle_ls",
    },
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

-- Render Markdown configuration
require("render-markdown").setup({})

-- Initialize Mason
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
        -- Web Development
        "angularls", -- Angular
        "ts_ls", -- TypeScript/JavaScript
        "eslint", -- ESLint
        "html", -- HTML
        "cssls", -- CSS
        "jsonls", -- JSON
        "yamlls", -- YAML
        "dockerls", -- Docker
        "taplo", -- TOML

        -- Backend Languages
        "pyright", -- Python
        "gopls", -- Go
        "omnisharp", -- C#
        "jdtls", -- Java
        "kotlin_language_server", -- Kotlin
        "clangd", -- C/C++
        "rust_analyzer", -- Rust
        "elixirls", -- Elixir
        "zls", -- Zig
        "sqlls", -- SQL

        "gradle_ls", -- Gradle

        -- Scripting
        "bashls", -- Bash
        "lua_ls", -- Lua
        "awk_ls", -- AWK

        -- Markup
        "texlab", -- LaTeX
        "lemminx", -- XML
    },
})

local capabilities = require("cmp_nvim_lsp").default_capabilities()
local lspconfig = require("lspconfig")

-- Enhanced on_attach function
local on_attach = function(client, bufnr)
    -- Enable formatting on save
    vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = bufnr,
        callback = function()
            vim.lsp.buf.format()
        end,
    })

    -- Key mappings
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

-- Language-specific configurations
local configs = {
    -- Web Development
    angularls = {
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { "typescript", "html", "typescriptreact", "typescript.tsx" },
        root_dir = lspconfig.util.root_pattern("angular.json", "package.json"),
    },
    ts_ls = {
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { "typescript", "javascript", "typescriptreact", "typescript.tsx" },
        root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json"),
    },
    eslint = {
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { "typescript", "javascript", "typescriptreact", "typescript.tsx" },
    },
    html = {
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { "html", "htmldjango" },
    },
    cssls = {
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { "css", "scss", "less" },
    },
    jsonls = {
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
            json = {
                schemas = require("schemastore").json.schemas(),
                validate = { enable = true },
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

    -- Backend Languages
    pyright = {
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
        on_attach = on_attach,
        cmd = {
            "clangd",
            "--background-index",
            "--suggest-missing-includes",
            "--clang-tidy",
            "--header-insertion=iwyu",
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
                fetchDeps = true,
                mixEnv = "dev",
            },
        },
    },
    zls = {
        capabilities = capabilities,
        on_attach = on_attach,
    },

    -- Scripting
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
                workspace = {
                    checkThirdParty = false,
                    library = {
                        vim.env.VIMRUNTIME,
                    },
                },
                telemetry = {
                    enable = false,
                },
            },
        },
    },
    awk_ls = {
        capabilities = capabilities,
        on_attach = on_attach,
    },

    -- Markup
    texlab = {
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
            texlab = {
                build = {
                    executable = "latexmk",
                    args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
                    forwardSearchAfter = true,
                },
                forwardSearch = {
                    executable = "displayline",
                    args = { "%l", "%p", "%f" },
                },
            },
        },
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

    -- SQL LSP configuration
    sqlls = {
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
            sqlLanguageServer = {
                connections = {
                    -- Development database
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

-- Setup all language servers
for server, config in pairs(configs) do
    lspconfig[server].setup(config)
end

-- Additional diagnostics configuration
vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = false,
})

-- Enable border for floating windows
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
