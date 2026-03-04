require("visual-whitespace").setup({})

vim.keymap.set({ "n", "v" }, "<leader>vv", function()
    require("visual-whitespace").toggle()
end, { desc = "Visual whitespace toggle" })
