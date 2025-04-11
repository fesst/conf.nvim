vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
	use 'wbthomason/packer.nvim'
	use {
		'neovim/nvim-lspconfig',
		requires = {
			'williamboman/mason.nvim',
			'williamboman/mason-lspconfig.nvim',
			'hrsh7th/cmp-nvim-lsp'
		}
	}
	use {
		'hrsh7th/nvim-cmp',
		requires = {
			'hrsh7th/cmp-buffer',
			'hrsh7th/cmp-path',
			'hrsh7th/cmp-nvim-lsp'
		}
	}
	use {
		'mfussenegger/nvim-dap'
	}
	use 'mfussenegger/nvim-jdtls'
	-- Formatting
	use 'jose-elias-alvarez/null-ls.nvim'
	use {
		'nvim-telescope/telescope.nvim', tag = '0.1.8',
		-- or                            , branch = '0.1.x',
		requires = { {'nvim-lua/plenary.nvim'} }
	}
	use {
		'rose-pine/neovim',
		as = 'rose-pine',
		config = function()
			vim.cmd('colorscheme rose-pine');
		end
	}
	use('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'});
	use('nvim-treesitter/playground');
	use('mbbill/undotree')
	use('theprimeagen/harpoon')
	use('github/copilot.vim' )
	use({
		'nvim-tree/nvim-tree.lua',
		requires = {
			'nvim-tree/nvim-web-devicons', -- optional
		}
	})
	use({
		'MeanderingProgrammer/render-markdown.nvim',
		after = { 'nvim-treesitter' },
		requires = { 'nvim-tree/nvim-web-devicons', opt = true },
		config = function()
			require('render-markdown').setup({})
		end,
	})
	use {
		'nvim-lualine/lualine.nvim',
		requires = { 'nvim-tree/nvim-web-devicons', opt = true },
	}
end)
