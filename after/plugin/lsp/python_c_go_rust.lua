local ssh_utils = require("motleyfesst.ssh_utils")
if not ssh_utils.IS_LOCAL() then
    return
end
local lsp_utils = require("motleyfesst.lsp_utils")

local function setup_tabs(tab_size, expand_tab)
    vim.opt_local.tabstop = tab_size
    vim.opt_local.shiftwidth = tab_size
    vim.opt_local.softtabstop = tab_size
    vim.opt_local.expandtab = expand_tab
end
local function setup_language_settings()
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "go",
        callback = function()
            setup_tabs(4, false)
        end,
    })
    vim.api.nvim_create_autocmd("FileType", {
        pattern = { "c", "cpp" },
        callback = function()
            setup_tabs(4, true)
        end,
    })
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "rust",
        callback = function()
            setup_tabs(4, true)
            vim.opt_local.colorcolumn = "100"
            vim.opt_local.textwidth = 100
            vim.opt_local.formatoptions:append("c") -- Auto-wrap comments
            vim.opt_local.formatoptions:append("q") -- Allow formatting of comments with 'gq'
            vim.opt_local.formatoptions:append("r") -- Auto-insert comment leader after hitting <Enter>
            vim.opt_local.formatoptions:append("n") -- Recognize numbered lists
            vim.opt_local.formatoptions:append("j") -- Remove comment leader when joining lines
        end,
    })
end

setup_language_settings()
--
--
--

local capabilities = lsp_utils.make_capabilities()
local on_attach = lsp_utils.default_on_attach
-- Python
vim.lsp.config("pyright", {
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
vim.lsp.enable("pyright")

-- C/C++
vim.lsp.config("clangd", {
    capabilities = capabilities,
    on_attach = on_attach,
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
vim.lsp.enable("clangd")
