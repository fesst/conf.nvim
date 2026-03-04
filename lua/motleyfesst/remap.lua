vim.g.mapleader = " "

local base_options = { noremap = true, silent = true }

local function map(mode, lhs, rhs, opts)
    local merged_opts = opts and vim.tbl_extend("force", base_options, opts) or base_options
    vim.keymap.set(mode, lhs, rhs, merged_opts)
end

local ssh_utils = require("motleyfesst.ssh_utils")
local function terminal()
    vim.o.shell = ssh_utils.IS_ZSH() and "/bin/zsh -i" or "/usr/bin/bash --login"

    map({ "n", "v" }, "<leader>TT", function()
        vim.cmd("botright " .. math.floor(vim.o.lines / 4) .. "split")
        vim.cmd("setlocal modified")
        vim.cmd("terminal")
        vim.cmd("startinsert")
    end, {})
    map({ "n", "v" }, "<leader>Tt", function()
        vim.cmd("rightbelow " .. math.floor(vim.o.columns / 2.1) .. "vsplit")
        vim.cmd("setlocal modified")
        vim.cmd("terminal")
        vim.cmd("startinsert")
    end, {})
    map("t", "<A-q>", "<C-\\><C-n>", {})
end

local function leader_motions()
    map("n", "<leader>R", ":source %<CR>")
    map("n", "<leader>w", ":write %<CR>")
    map("n", "<leader>q", ":wq<CR>")
    map("n", "<leader>m", ":messages<CR>")

    map("n", "<leader>*", ":nohlsearch<CR>")

    map("v", "<leader>8", '"*y')
    map("v", "<leader>=", '"+y')

    map("n", "<leader>gf", ":new <cfile><CR>")
    map("v", "<leader>gf", ":new <cfile><CR>")
    map("n", "<leader>gF", ":vnew <cfile><CR>")
    map("v", "<leader>gF", ":vnew <cfile><CR>")
end

local function jdtls_motions()
    local function with_jdtls(cb)
        return function()
            local ok, jdtls = pcall(require, "jdtls")
            if not ok then
                vim.notify("jdtls is not available in this buffer", vim.log.levels.WARN)
                return
            end
            cb(jdtls)
        end
    end

    map(
        "n",
        "crv",
        with_jdtls(function(jdtls)
            jdtls.extract_variable()
        end)
    )
    map(
        "v",
        "crv",
        with_jdtls(function(jdtls)
            jdtls.extract_variable(true)
        end)
    )
    map(
        "n",
        "crc",
        with_jdtls(function(jdtls)
            jdtls.extract_constant()
        end)
    )
    map(
        "v",
        "crc",
        with_jdtls(function(jdtls)
            jdtls.extract_constant(true)
        end)
    )
    map(
        "v",
        "crm",
        with_jdtls(function(jdtls)
            jdtls.extract_method(true)
        end)
    )

    map(
        "n",
        "<leader>df",
        with_jdtls(function(jdtls)
            jdtls.test_class()
        end)
    )
    map(
        "n",
        "<leader>dn",
        with_jdtls(function(jdtls)
            jdtls.test_nearest_method()
        end)
    )
end

local function completion_motions()
    local function trigger_completion()
        local ok, cmp = pcall(require, "cmp")
        if not ok then
            vim.notify("nvim-cmp is not available", vim.log.levels.WARN)
            return
        end

        local mode = vim.fn.mode()
        if mode == "n" then
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("i", true, false, true), "n", false)
        elseif mode:match("[vV\22]") then
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>i", true, false, true), "n", false)
        end

        vim.schedule(function()
            cmp.complete()
        end)
    end

    map({ "n", "v" }, "<leader><C-Space>", trigger_completion, { desc = "Completion menu" })
    map({ "n", "v" }, "<leader><C-@>", trigger_completion, { desc = "Completion menu" })
end

local function embrace_visual()
    map("v", "<leader>b(", "c()<Esc>P")
    map("v", "<leader>b[", "c[]<Esc>P")
    map("v", "<leader>b{", "c{}<Esc>P")
    map("v", "<leader>b<", "c<><Esc>P")
    map("v", "<leader>b'", "c''<Esc>P")
    map("v", '<leader>b"', 'c""<Esc>P')
    map("v", "<leader>b`", "c``<Esc>P")
end

local function add_pair_big_motion()
    map("n", "<leader>ba(", "A()<Esc>")
    map("n", "<leader>ba[", "A[]<Esc>")
    map("n", "<leader>ba{", "A{}<Esc>")
    map("n", "<leader>ba<", "A<><Esc>")

    map("n", "<leader>bi(", "I()<Esc>")
    map("n", "<leader>bi[", "I[]<Esc>")
    map("n", "<leader>bi{", "I{}<Esc>")
    map("n", "<leader>bi<", "I<><Esc>")
end

local function smart_delete_brackets(open_char, close_char)
    return function()
        vim.cmd("normal! F" .. open_char .. "x" .. "f" .. close_char .. "x")
    end
end

local function delete_pairs()
    map("n", "<leader>B(", smart_delete_brackets("(", ")"))
    map("n", "<leader>B[", smart_delete_brackets("[", "]"))
    map("n", "<leader>B{", smart_delete_brackets("{", "}"))
    map("n", "<leader>B<", smart_delete_brackets("<", ">"))
    map("n", "<leader>B'", smart_delete_brackets("'", "'"))
    map("n", '<leader>B"', smart_delete_brackets('"', '"'))
    map("n", "<leader>B`", smart_delete_brackets("`", "`"))
end

local function wrap_brackets()
    local bracket_pairs = { ["("] = ")", ["["] = "]", ["{"] = "}", ["<"] = ">", ['"'] = '"', ["'"] = "'", ["`"] = "`" }

    local function wrap_under_cursor(open)
        local close = bracket_pairs[open]
        if not close then
            return nil
        end

        local row, col0 = unpack(vim.api.nvim_win_get_cursor(0))
        local line = vim.api.nvim_get_current_line()
        if line == "" then
            return
        end
        local col = math.max(1, math.min(col0 + 1, #line))

        local left, right = nil, nil
        for i = col, 1, -1 do
            if line:sub(i, i) == open then
                left = i
                break
            end
        end
        for i = col + 1, #line do
            if line:sub(i, i) == close then
                right = i
                break
            end
        end

        if left and right and left < right then
            vim.api.nvim_set_current_line(
                line:sub(1, left) .. open .. line:sub(left + 1, right - 1) .. close .. line:sub(right)
            )
            vim.api.nvim_win_set_cursor(0, { row, left + 1 })
        else
            local is_word = line:sub(col, col):match("[%w_]")
            if not is_word then
                return
            end

            local s = col
            while s > 1 and line:sub(s - 1, s - 1):match("[%w_]") do
                s = s - 1
            end
            local e = col
            while e < #line and line:sub(e + 1, e + 1):match("[%w_]") do
                e = e + 1
            end
            local word = line:sub(s, e)
            vim.api.nvim_set_current_line(line:sub(1, s - 1) .. open .. word .. close .. line:sub(e + 1))
            vim.api.nvim_win_set_cursor(0, { row, s + 1 })
        end
    end

    for symbol, _ in pairs(bracket_pairs) do
        vim.keymap.set("n", "<leader>b" .. symbol, function()
            return wrap_under_cursor(symbol)
        end, { noremap = true, silent = true })
    end
end

terminal()
leader_motions()
jdtls_motions()
completion_motions()
embrace_visual()
add_pair_big_motion()
delete_pairs()
wrap_brackets()
