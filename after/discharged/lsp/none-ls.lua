local configured = false

local function safe_require_builtin(path)
    local ok, builtin = pcall(require, path)
    if not ok then
        return nil
    end
    return builtin
end

local function setup_none_ls()
    if configured then
        return true
    end

    local ok_null_ls, null_ls = pcall(require, "null-ls")
    if not ok_null_ls then
        return false
    end

    local sources = {}
    local stylua = safe_require_builtin("null-ls.builtins.formatting.stylua")
    local shfmt = safe_require_builtin("null-ls.builtins.formatting.shfmt")
    local google_java_format = safe_require_builtin("null-ls.builtins.formatting.google_java_format")
    local shellcheck = safe_require_builtin("null-ls.builtins.diagnostics.shellcheck")
    local luacheck = safe_require_builtin("null-ls.builtins.diagnostics.luacheck")

    if stylua then
        table.insert(sources, stylua)
    end
    if shfmt then
        table.insert(sources, shfmt.with({ extra_args = { "-i", "2", "-ci" } }))
    end
    if google_java_format then
        local google_java_format_bin = vim.fn.stdpath("data") .. "/mason/bin/google-java-format" -- ===<GOOGLE_JAVA_FORMAT_BIN>===
        table.insert(
            sources,
            google_java_format.with({
                command = google_java_format_bin,
                extra_args = { "--skip-sorting-imports", "--skip-removing-unused-imports" },
            })
        )
    end
    if shellcheck then
        table.insert(
            sources,
            shellcheck.with({ filetypes = { "sh", "bash", "zsh" } })
        )
    end
    if luacheck then
        table.insert(sources, luacheck)
    end

    null_ls.setup({ debug = false, sources = sources })
    configured = true
    return true
end

if setup_none_ls() then
    return
end

vim.api.nvim_create_autocmd("User", {
    pattern = "LazyLoad",
    callback = function(ev)
        local plugin = ev.data
        if type(plugin) == "table" then
            plugin = plugin.name or plugin[1]
        end

        if plugin == "nvimtools/none-ls.nvim" or plugin == "none-ls.nvim" then
            setup_none_ls()
        end
    end,
})
