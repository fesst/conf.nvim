local ssh_utils = require("motleyfesst.ssh_utils")

if not ssh_utils.IS_LOCAL() then
    return
end

local lsp_utils = require("motleyfesst.lsp_utils")
local capabilities = lsp_utils.make_capabilities()

vim.lsp.config("graphql", {
    on_attach = function(_, bufnr)
        lsp_utils.default_on_attach(nil, bufnr)
    end,
    filetypes = { "graphqls", "graphql", "gql", "json", "ts", "js" },
    flags = {
        debounce_text_changes = 150,
    },
    capabilities = capabilities,
})

vim.lsp.config.graphql.root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    on_dir(
        require("lspconfig.util").root_pattern(
            ".graphql.config.*",
            ".graphqlconfig",
            ".graphqlrc",
            ".graphqlrc*",
            "graphql.config.*",
            "package.json"
        )(fname)
    )
end

vim.lsp.enable("graphql")
