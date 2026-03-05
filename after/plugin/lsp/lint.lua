local ssh_utils = require("motleyfesst.ssh_utils")
if not ssh_utils.IS_LOCAL() then
    return
end

local LOG_TAG = "[nvim-lint]"

local ok, lint = pcall(require, "lint")
if not ok then
    vim.notify(LOG_TAG .. " nvim-lint not found, skipping setup", vim.log.levels.DEBUG)
    return
end

lint.linters_by_ft = {
    lua = { "luacheck" },
    sh = { "shellcheck" },
    bash = { "shellcheck" },
    zsh = { "shellcheck" },
}

local lint_group = vim.api.nvim_create_augroup("NvimLint", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
    group = lint_group,
    callback = function()
        local ok_lint, lint_mod = pcall(require, "lint")
        if ok_lint then
            lint_mod.try_lint()
        end
    end,
})
