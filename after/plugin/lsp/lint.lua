local ssh_utils = require("motleyfesst.utils.ssh")
if not ssh_utils.IS_LOCAL() then
    return
end

local lint = require("lint")

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
        local ft = vim.bo[args.buf].filetype
        local names = lint.linters_by_ft[ft] or {}
        if vim.tbl_isempty(names) then
            return
        end

        lint.try_lint(names, { ignore_errors = true })
    end,
})
