return {
	{
		"RRethy/vim-illuminate",
		event = "VeryLazy",
	},
	{
		"ray-x/lsp_signature.nvim",
		event = "VeryLazy",
		opts = {},
	},
	{
		'weilbith/nvim-code-action-menu',
		event = "VeryLazy",
		cmd = 'CodeActionMenu',
		keys = {
			{ '<leader>c', '<cmd>CodeActionMenu<CR>' },
		},
	},
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		opts = {
			open_mapping = [[<A-\>]]
		}
	},
	{
		'nvim-tree/nvim-tree.lua',
		opts = {
			select_prompts = true,
			view = {
				mappings = {
					custom_only = false,
					list = {
						{ key = "l", action = "edit",           action_cb = edit_or_open },
						{ key = "L", action = "vsplit_preview", action_cb = vsplit_preview },
						{ key = "h", action = "close_node" },
						{ key = "H", action = "collapse_all",   action_cb = collapse_all }
					}
				},
			},
			actions = {
				open_file = {
					quit_on_open = false
				},
			},
		},
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		keys = {
			{ "<C-n>",     "<cmd>NvimTreeToggle<CR>" },
			{ "<leader>n", "<cmd>NvimTreeFocus<CR>" },
		}
	},
	{
		'nvim-telescope/telescope.nvim',
		dependencies = { 'nvim-lua/plenary.nvim' },
		cmd = "Telescope",
		keys = {
			{ "<leader>ff", "<cmd>Telescope find_files<CR>" },
			{ "<leader>fg", "<cmd>Telescope live_grep<CR>" },
			{ "<leader>sk", "<cmd>Telescope keymaps<CR>" },
		}
	},
	{
		"jubnzv/virtual-types.nvim"
	},
	{
		"numToStr/Comment.nvim",
		config = function()
			require('Comment').setup()
		end
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		opts = {},
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
		"romgrk/barbar.nvim",
		lazy = false,
		dependencies = "nvim-tree/nvim-web-devicons",
		init = function() vim.g.barbar_auto_setup = false end,
		opts = {
		},
		keys = {
			{ "<Tab>",     "<cmd>BufferNext<CR>" },
			{ "<S-Tab>",   "<cmd>BufferPrev<CR>" },
			{ "<leader>x", "<cmd>BufferClose<CR>" }
		}
	},
	{
		"windwp/nvim-ts-autotag",
	},
	{
		"HiPhish/nvim-ts-rainbow2",
	},
	{
		"lukas-reineke/indent-blankline.nvim",
	},
	{
		"windwp/nvim-autopairs",
		event = "VeryLazy",
		opts = {},
	},
	{
		"dccsillag/magma-nvim",
	},
	{
		"meatballs/notebook.nvim",
		opts = {}
	}
}
