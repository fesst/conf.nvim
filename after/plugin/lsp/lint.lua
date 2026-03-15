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

local function has_executable(cmd)
    return vim.fn.executable(cmd) == 1
end

local linters_by_ft = {}
if has_executable("luacheck") then
    linters_by_ft.lua = { "luacheck" }
end
if has_executable("shellcheck") then
    linters_by_ft.sh = { "shellcheck" }
    linters_by_ft.bash = { "shellcheck" }
    linters_by_ft.zsh = { "shellcheck" }
end

lint.linters_by_ft = linters_by_ft

local lint_group = vim.api.nvim_create_augroup("NvimLint", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
    group = lint_group,
    callback = function(args)
        local ok_lint, lint_mod = pcall(require, "lint")
        if not ok_lint then
            return
        end

        local ft = vim.bo[args.buf].filetype
        local names = lint_mod.linters_by_ft[ft] or {}
        if vim.tbl_isempty(names) then
            return
        end

        lint_mod.try_lint(names, { ignore_errors = true })
    end,
})
