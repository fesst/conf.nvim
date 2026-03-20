local ssh_utils = require("motleyfesst.utils.ssh")

if ssh_utils.IS_LOCAL() then
    local bazel_utils = require("motleyfesst.utils.bazel")
    local lsp_utils = require("motleyfesst.utils.lsp")
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
            "clangd",
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

    lsp_utils.setup_server("angularls", {
        filetypes = { "typescript", "html", "typescriptreact", "typescript.tsx" },
        root_markers = { "angular.json", "project.json" },
    })
    -- TypeScript/JavaScript
    lsp_utils.setup_server("ts_ls", {
        filetypes = { "typescript", "javascript", "typescriptreact", "typescript.tsx" },
        root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
        settings = {
            typescript = { folding = true },
            javascript = { folding = true },
        },
    })
    -- ESLintformat
    lsp_utils.setup_server("eslint", {
        filetypes = { "typescript", "javascript", "typescriptreact", "typescript.tsx" },
        root_markers = {
            ".eslintrc", ".eslintrc.js", ".eslintrc.json", ".eslintrc.yml",
            "eslint.config.js", "eslint.config.mjs", "package.json",
        },
    })
    lsp_utils.setup_server("html", {
        filetypes = { "html", "htmldjango" },
        root_markers = { "package.json", ".git" },
        settings = {
            html = { folding = true },
        },
    })

    lsp_utils.setup_server("cssls", {
        filetypes = { "css", "scss", "less" },
        root_markers = { "package.json", ".git" },
        settings = {
            css = { folding = true },
        },
    })

    lsp_utils.setup_server("jsonls", {
        root_markers = { "package.json", ".git" },
        settings = {
            json = {
                schemas = require("schemastore").json.schemas(),
                validate = { enable = true },
                folding = true,
            },
        },
    })

    lsp_utils.setup_server("yamlls", {
        root_markers = { ".git" },
        settings = {
            yaml = {
                schemas = require("schemastore").yaml.schemas(),
            },
        },
    })

    lsp_utils.setup_server("kotlin_language_server", {
        root_markers = { "build.gradle", "build.gradle.kts", "settings.gradle", "settings.gradle.kts", "pom.xml" },
    })
    -- Bash
    lsp_utils.setup_server("bashls", {
        filetypes = { "sh", "zsh", "bash" },
        root_markers = { ".git" },
        settings = {
            bashls = { folding = true, shiftwidth = 4 },
            zsh = { folding = true, shiftwidth = 4 },
            sh = { folding = true, shiftwidth = 4 },
        },
    })

    lsp_utils.setup_server("lua_ls", {
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

    -- Optional servers moved to after/discharged/lsp/optional_servers.lua

    lsp_utils.setup_server("dockerls", {
        root_markers = { "Dockerfile", "docker-compose.yml", "docker-compose.yaml", ".git" },
    })

    lsp_utils.setup_server("starpls", {
        on_attach = lsp_utils.extend_on_attach(function(_, bufnr)
            bazel_utils.detach_conflicting_starlark_clients(bufnr)
        end),
        root_markers = bazel_utils.root_markers(),
        filetypes = { "bzl", "bazel", "BUILD.bazel", "WORKSPACE", "WORKSPACE.bazel" },
        settings = {
            starpls = {
                bazel = {
                    executable = "bazel",
                },
            },
        },
    })

    -- bazelrc_lsp: Bazel RC file language server
    lsp_utils.setup_server("bazelrc_lsp", {
        root_markers = bazel_utils.root_markers({ ".bazelrc" }),
    })

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
