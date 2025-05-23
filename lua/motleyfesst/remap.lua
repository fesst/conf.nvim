-- Set leader key
vim.g.mapleader = " "

-- Bracket-related mappings
local function map(mode, lhs, rhs, opts)
    local options = { noremap = true, silent = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.keymap.set(mode, lhs, rhs, options)
end

-- Surround with brackets (visual mode)
map("v", "<leader>b(", "xi()<Esc>P")
map("v", "<leader>b[", "xi[]<Esc>P")
map("v", "<leader>b{", "xi{}<Esc>P")
map("v", "<leader>b<", "xi<><Esc>P")
map("v", "<leader>b'", "xi''<Esc>P")
map("v", "<leader>b\"", "xi\"\"<Esc>P")
map("v", "<leader>b`", "xi``<Esc>P")

-- Surround with brackets (normal mode)
map("n", "<leader>b(", "viwxi()<Esc>P")
map("n", "<leader>b[", "viwxi[]<Esc>P")
map("n", "<leader>b{", "viwxi{}<Esc>P")
map("n", "<leader>b<", "viwxi<><Esc>P")
map("n", "<leader>b'", "viwxi''<Esc>P")
map("n", "<leader>b\"", "viwxi\"\"<Esc>P")
map("n", "<leader>b`", "viwxi``<Esc>P")

-- Delete surrounding brackets
map("n", "<leader>bd(", "F(xf)")
map("n", "<leader>bd[", "F[xf]")
map("n", "<leader>bd{", "F{xf}")
map("n", "<leader>bd<", "F<xf>")
map("n", "<leader>bd'", "F'xf'")
map("n", "<leader>bd\"", "F\"xf\"")
map("n", "<leader>bd`", "F`xf`")

-- Change surrounding brackets
map("n", "<leader>bc(", "F(xf)xi()<Esc>P")
map("n", "<leader>bc[", "F[xf]xi[]<Esc>P")
map("n", "<leader>bc{", "F{xf}xi{}<Esc>P")
map("n", "<leader>bc<", "F<xf>xi<><Esc>P")
map("n", "<leader>bc'", "F'xf'xi''<Esc>P")
map("n", "<leader>bc\"", "F\"xf\"xi\"\"<Esc>P")
map("n", "<leader>bc`", "F`xf`xi``<Esc>P")

-- Add brackets at the end of line
map("n", "<leader>ba(", "A()<Esc>i")
map("n", "<leader>ba[", "A[]<Esc>i")
map("n", "<leader>ba{", "A{}<Esc>i")
map("n", "<leader>ba<", "A<><Esc>i")
map("n", "<leader>ba'", "A''<Esc>i")
map("n", "<leader>ba\"", "A\"\"<Esc>i")
map("n", "<leader>ba`", "A``<Esc>i")

-- Add brackets at the start of line
map("n", "<leader>bi(", "I()<Esc>i")
map("n", "<leader>bi[", "I[]<Esc>i")
map("n", "<leader>bi{", "I{}<Esc>i")
map("n", "<leader>bi<", "I<><Esc>i")
map("n", "<leader>bi'", "I''<Esc>i")
map("n", "<leader>bi\"", "I\"\"<Esc>i")
map("n", "<leader>bi`", "I``<Esc>i")
