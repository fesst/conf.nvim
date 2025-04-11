require('telescope').setup({
	pickers= {
		old_files = {
			only_cwd = true,
			sort_lastused = true,
		},
		find_files = {
			hidden = true,
		},
		live_grep = {
			additional_args = {"--hidden"}
		},
		grep_string = {
			additional_args = {"--hidden"}
		},
	},
	extensions = {
		media_files = {
			-- filetypes whitelist
			-- defaults to {"png", "jpg", "mp4", "webm", "pdf"}
			filetypes = {"pdf", "png", "webp", "jpg", "jpeg"},
			-- find command (defaults to `fd`)
			find_cmd = "rg"
		}
	}})

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', builtin.find_files, { desc = 'Telescope find files' })

vim.keymap.set('n', '<leader>pe', builtin.oldfiles, { desc = 'Telescope old files' })
vim.keymap.set('n', '<leader>ps',
	function()
		return builtin.grep_string({ search = vim.fn.input("Grep > ") });
	end, { desc = 'Telescope grep string' })
vim.keymap.set('n', '<leader>pg', builtin.git_files, { desc = 'Telescope git files' })
-- required brew install ripgrep
vim.keymap.set('n', '<leader>pl', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>ph', builtin.help_tags, { desc = 'Telescope help tags' })

