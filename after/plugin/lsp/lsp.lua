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
        root_markers = { "angular.json", "project.json" },
    })
    vim.lsp.enable("angularls")
    -- TypeScript/JavaScript
    vim.lsp.config("ts_ls", {
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { "typescript", "javascript", "typescriptreact", "typescript.tsx" },
        root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
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
        root_markers = {
            ".eslintrc", ".eslintrc.js", ".eslintrc.json", ".eslintrc.yml",
            "eslint.config.js", "eslint.config.mjs", "package.json",
        },
    })
    vim.lsp.enable("eslint")
    vim.lsp.config("html", {
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { "html", "htmldjango" },
        root_markers = { "package.json", ".git" },
        settings = {
            html = { folding = true },
        },
    })
    vim.lsp.enable("html")

    vim.lsp.config("cssls", {
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { "css", "scss", "less" },
        root_markers = { "package.json", ".git" },
        settings = {
            css = { folding = true },
        },
    })
    vim.lsp.enable("cssls")

    vim.lsp.config("jsonls", {
        capabilities = capabilities,
        on_attach = on_attach,
        root_markers = { "package.json", ".git" },
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
        root_markers = { ".git" },
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
        root_markers = { "build.gradle", "build.gradle.kts", "settings.gradle", "settings.gradle.kts", "pom.xml" },
    })
    vim.lsp.enable("kotlin_language_server")
    -- Bash
    vim.lsp.config("bashls", {
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { "sh", "zsh", "bash" },
        root_markers = { ".git" },
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
        root_markers = { ".luarc.json", ".luarc.jsonc", ".luacheckrc", "stylua.toml", ".stylua.toml", ".git" },
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

    -- Optional servers moved to after/discharged/lsp/optional_servers.lua

    vim.lsp.config("dockerls", {
        capabilities = capabilities,
        on_attach = on_attach,
        root_markers = { "Dockerfile", "docker-compose.yml", "docker-compose.yaml", ".git" },
    })
    vim.lsp.enable("dockerls")

    -- starpls: explicit config so neovim correctly sets the server's CWD to the
    -- Bazel workspace root. Without this, starpls inherits nvim's process CWD and
    -- `bazel info` fails in "batch mode" when nvim was launched outside the workspace.
    vim.lsp.config("starpls", {
        capabilities = capabilities,
        on_attach = on_attach,
        root_markers = { "MODULE.bazel", "WORKSPACE.bazel", "WORKSPACE" },
        filetypes = { "bzl", "bazel", "BUILD.bazel", "WORKSPACE", "WORKSPACE.bazel" },
        settings = {
            starpls = {
                bazel = {
                    executable = "bazel",
                },
            },
        },
    })
    vim.lsp.enable("starpls")

    -- bazelrc_lsp: Bazel RC file language server
    vim.lsp.config("bazelrc_lsp", {
        capabilities = capabilities,
        on_attach = on_attach,
        root_markers = { "MODULE.bazel", "WORKSPACE.bazel", "WORKSPACE", ".bazelrc" },
    })
    vim.lsp.enable("bazelrc_lsp")

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

    vim.api.nvim_create_autocmd("BufReadPost", {
        pattern = { "*.txt", "*.text", "*.md", "*.markdown" },
        callback = function()
            vim.diagnostic.hide()
        end,
    })

    require("render-markdown").setup({
        latex = { enabled = false },
    })
end
