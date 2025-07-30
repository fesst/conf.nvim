require("visual-whitespace").setup({})

vim.keymap.set( { "n", "v" }, "<leader>vv" , function()
    return require("visual-whitespace").toggle
end, { desc = "Visual whitespace toggle" })

