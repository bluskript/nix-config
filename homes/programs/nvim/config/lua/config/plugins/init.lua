return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require('nvim-treesitter.configs').setup({
				ensure_installed = "all",
				highlight = { enable = true },
				indent = { enable = true },
			})
		end,
	},
	{
		"folke/which-key.nvim",
		config = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
			require("which-key").setup({})
		end,
	},
	{
		"tiagovla/tokyodark.nvim",
		name = "tokyodark",
	},
	{
		"phaazon/hop.nvim",
		branch = "v2",
		keys = {
			{ "f", "<cmd>HopWord<cr>" },
			{ "F", "<cmd>HopLineStart<cr>" },
		},
		config = function()
			require('hop').setup()
		end
	},
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
		},
		config = function()
			local cmp = require('cmp')
			cmp.setup({
				sources = cmp.config.sources({
					{ name = 'nvim_lsp' },
				})
			}, {
				{ name = 'buffer' }
			})
		end,
	}
}
