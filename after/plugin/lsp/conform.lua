local ssh_utils = require("motleyfesst.ssh_utils")
if not ssh_utils.IS_LOCAL() then
    return
end

local LOG_TAG = "[conform]"

local ok, conform = pcall(require, "conform")
if not ok then
    vim.notify(LOG_TAG .. " conform.nvim not found, skipping setup", vim.log.levels.DEBUG)
    return
end

conform.setup({
    formatters_by_ft = {
        lua = { "stylua" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        zsh = { "shfmt" },
        java = { "google-java-format" },
        python = { "black", "isort", stop_after_first = true },
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
            prepend_args = { "-i", "2", "-ci" },
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
