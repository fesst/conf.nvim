vim.g.mapleader = " "

local options = { noremap = true, silent = true }

local function map(mode, lhs, rhs, opts)
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.keymap.set(mode, lhs, rhs, options)
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
    map("t", "<C-q>", "<C-\\><C-n>", {})
end

local function leader_motions()
    map("n", "<leader>R", ":source %<CR>")
    map("n", "<leader>w", ":write %<CR>")
    map("n", "<leader>q", ":wq%<CR>")
    map("n", "<leader>m", ":messages<CR>")

    map("n", "<leader>*", ":nohlsearch<CR>")
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

        local row, col = unpack(vim.api.nvim_win_get_cursor(0))
        local line = vim.api.nvim_get_current_line()

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
                line:sub(1, left) .. open .. line:sub(left + 1, right - 1) .. line:sub(right) .. after
            )
            vim.api.nvim_win_set_cursor(0, { row, left + 1 })
        else
            local word = vim.fn.expand("<cword>")
            local s = line:find(word, 1, true)
            if not s then
                return
            end
            local e = s + #word
            vim.api.nvim_set_current_line(line:sub(1, s - 1) .. open .. word .. close .. line:sub(e))
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
embrace_visual()
add_pair_big_motion()
delete_pairs()
wrap_brackets()
