require("telescope").setup({
    pickers = {
        old_files = {
            only_cwd = true,
            sort_lastused = true,
        },
        find_files = {
            hidden = true,
        },
        live_grep = {
            additional_args = { "--hidden" },
        },
        grep_string = {
            additional_args = { "--hidden" },
        },
    },
    extensions = {
        media_files = {
            filetypes = { "pdf", "png", "webp", "jpg", "jpeg" },-- defaults to {"png", "jpg", "mp4", "webm", "pdf"}
            find_cmd = "rg",-- find command (defaults to `fd`)
        },
    },
})

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>tz", builtin.lsp_reference, { desc = "Telescope refs" })
vim.keymap.set("n", "<leader>ta", builtin.autocommands, { desc = "Telescope autocommands" })
vim.keymap.set("n", "<leader>tb", builtin.buffers, {desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>tc", builtin.commands, { desc = "Telescope commands" })
vim.keymap.set("n", "<leader>te", builtin.oldfiles, { desc = "Telescope old files" })
vim.keymap.set("n", "<leader>tf", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>tg", builtin.git_files, { desc = "Telescope git files" })
vim.keymap.set("n", "<leader>th", builtin.help_tags, { desc = "Telescope help tags" })
vim.keymap.set("n", "<leader>ti", builtin.highlights, { desc = "Telescope highlights" })
vim.keymap.set("n", "<leader>tj", builtin.jumplist, { desc = "Telescope jumplist"})
vim.keymap.set("n", "<leader>tk", builtin.keymaps, { desc = "Telescope keymaps" })
vim.keymap.set("n", "<leader>tl", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>tm", builtin.marks, { desc = "Telescope marks" })
vim.keymap.set("n", "<leader>tp", builtin.man_pages, { desc = "Telescope manuals" })
vim.keymap.set("n", "<leader>tq", builtin.quickfixhistory, { desc = "Telescope quickfix history" })
vim.keymap.set("n", "<leader>tr", builtin.registers, { desc = "Telescope registers" })
vim.keymap.set("n", "<leader>tt", function()
    return builtin.grep_string({ search = vim.fn.input("Grep > ") })
end, { desc = "Telescope grep string" })
vim.keymap.set("n", "<leader>tu", builtin.resume, { desc = "Telescope resume" })
vim.keymap.set("n", "<leader>tv", builtin.vim_options, { desc = "Telescope vim options" })
