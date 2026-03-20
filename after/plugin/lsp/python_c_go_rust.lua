local ssh_utils = require("motleyfesst.utils.ssh")
if not ssh_utils.IS_LOCAL() then
    return
end
local lsp_utils = require("motleyfesst.utils.lsp")

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

lsp_utils.setup_server("pyright", {
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

-- C/C++
lsp_utils.setup_server("clangd", {
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
