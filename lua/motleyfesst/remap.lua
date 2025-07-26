vim.g.mapleader = " "

local options = { noremap = true, silent = true }
local function map(mode, lhs, rhs, opts)
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.keymap.set(mode, lhs, rhs, options)
end

map("n", "<leader>m", ":messages<CR>")
map("n", "<leader>R", ":source %<CR>")
map("n", "<leader>w", ":write %<CR>")

map("n", "<leader>*", ":nohlsearch<CR>")

map("v", "<leader>b(", "c()<Esc>P")
map("v", "<leader>b[", "c[]<Esc>P")
map("v", "<leader>b{", "c{}<Esc>P")
map("v", "<leader>b<", "c<><Esc>P")
map("v", "<leader>b'", "c''<Esc>P")
map("v", '<leader>b"', 'c""<Esc>P')
map("v", "<leader>b`", "c``<Esc>P")

map("n", "<leader>ba(", "A()<Esc>")
map("n", "<leader>ba[", "A[]<Esc>")
map("n", "<leader>ba{", "A{}<Esc>")
map("n", "<leader>ba<", "A<><Esc>")

map("n", "<leader>bi(", "I()<Esc>")
map("n", "<leader>bi[", "I[]<Esc>")
map("n", "<leader>bi{", "I{}<Esc>")
map("n", "<leader>bi<", "I<><Esc>")
map("n", "<leader>bi'", "I''<Esc>")
map("n", '<leader>bi"', 'I""<Esc>')
map("n", "<leader>bi`", "I``<Esc>")

local function smart_delete_brackets(open_char, close_char)
    return function()
        -- Correct deletion: find opening bracket, delete it, find closing bracket, delete it
        vim.cmd("normal! F" .. open_char .. "x" .. "f" .. close_char .. "x")
    end
end

map("n", "<leader>B(", smart_delete_brackets("(", ")"))
map("n", "<leader>B[", smart_delete_brackets("[", "]"))
map("n", "<leader>B{", smart_delete_brackets("{", "}"))
map("n", "<leader>B<", smart_delete_brackets("<", ">"))
map("n", "<leader>B'", smart_delete_brackets("'", "'"))
map("n", '<leader>B"', smart_delete_brackets('"', '"'))
map("n", "<leader>B`", smart_delete_brackets("`", "`"))
