local ssh_utils = require("motleyfesst.utils.ssh")
if not ssh_utils.IS_LOCAL() then
    return
end

require("conform").setup({
    formatters_by_ft = {
        lua = { "stylua" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        zsh = { "shfmt" },
        java = { "google-java-format" },
        python = { "isort", "black" },
        javascript = { "prettier", stop_after_first = true },
        typescript = { "prettier", stop_after_first = true },
        typescriptreact = { "prettier", stop_after_first = true },
        javascriptreact = { "prettier", stop_after_first = true },
        json = { "prettier", stop_after_first = true },
        html = { "prettier", stop_after_first = true },
        css = { "prettier", stop_after_first = true },
        scss = { "prettier", stop_after_first = true },
        yaml = { "prettier", stop_after_first = true },
        markdown = { "prettier", stop_after_first = true },
    },
    formatters = {
        shfmt = {
            append_args = { "-ci" },
        },
        ["google-java-format"] = {
            command = vim.fn.stdpath("data") .. "/mason/bin/google-java-format",
            prepend_args = { "--skip-sorting-imports", "--skip-removing-unused-imports" },
        },
    },
    format_on_save = {
        timeout_ms = 3000,
        lsp_format = "fallback",
    },
    default_format_opts = {
        lsp_format = "fallback",
    },
})
