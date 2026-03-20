local ssh_utils = require("motleyfesst.utils.ssh")

if not ssh_utils.IS_LOCAL() then
    return
end

local lsp_utils = require("motleyfesst.utils.lsp")

vim.lsp.config("graphql", lsp_utils.with_defaults({
    filetypes = {
        "graphqls",
        "graphql",
        "gql",
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
    },
    flags = {
        debounce_text_changes = 150,
    },
}))

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
