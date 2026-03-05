-- Commented-out plugin entries removed from lua/motleyfesst/lazy.lua
-- To restore: add back to the appropriate list in lazy.lua

-- Copilot (Mac-only, config in after/discharged/ai/copilot.lua)
-- { "github/copilot.vim" },

-- nvim-cmp (replaced by blink.cmp, config in after/discharged/completion/nvim_cmp.lua)
-- {
--     "hrsh7th/nvim-cmp",
--     dependencies = {
--         "hrsh7th/cmp-buffer",
--         "hrsh7th/cmp-path",
--         "hrsh7th/cmp-nvim-lsp",
--         "nvim-lua/plenary.nvim",
--         "alexander-born/cmp-bazel",
--         "onsails/lspkind.nvim",
--     },
-- },

-- cmp-nvim-lsp dependency (was in nvim-lspconfig deps, replaced by blink.cmp)
-- "hrsh7th/cmp-nvim-lsp",

-- none-ls (replaced by conform.nvim + nvim-lint, config in after/discharged/lsp/none-ls.lua)
-- {
--     "nvimtools/none-ls.nvim",
--     dependencies = { "nvim-lua/plenary.nvim" },
--     event = { "BufReadPre", "BufNewFile" },
-- },

-- Alternative themes
-- {
--     "RRethy/base16-nvim",
--     lazy = false,
--     opts = { transparent = true, italic_comment = true },
--     config = function()
--         vim.cmd("colorscheme base16-material-palenight")
--     end,
-- },
-- {
--     "vague2k/vague.nvim",
--     'wilmanbarrios/palenight.nvim',
--     'alexmozaidze/palenight.nvim',
-- },

-- mason-lspconfig ensure_installed alternatives (in lsp.lua)
-- "clangd", "awk_ls", "texlab", "lemminx"

-- mason DAP adapters (in dap.lua ensure_dap_installed)
-- "debugpy", "netcoredbg", "elixir-ls"
