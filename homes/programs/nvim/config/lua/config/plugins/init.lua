return {
	{
		'weilbith/nvim-code-action-menu',
		cmd = 'CodeActionMenu',
		keys = {
			{ '<leader>c', '<cmd>CodeActionMenu<CR>' },
		},
	},
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		opts = {
			open_mapping = [[<C-\>]]
		}
	},
	{
		'gorbit99/codewindow.nvim',
		opts = {
			auto_enable = true,
			exclude_filetypes = { 'alpha', 'Trouble', 'packer', 'neorg', 'norg', 'Telescope', 'NvimTree' }
		},
		keys = {
			{ "<leader>mm", function() require('codewindow').toggle_minimap() end }
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
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require('nvim-treesitter.configs').setup({
				ensure_installed = "all",
				highlight = { enable = true },
				indent = { enable = true },
				autotag = {
					enable = true,
				},
				rainbow = {
					enable = true,
					extended_mode = true,
					max_file_lines = nil,
					hlgroups = {
						'TSRainbowYellow',
						'TSRainbowBlue',
						'TSRainbowOrange',
						'TSRainbowGreen',
						'TSRainbowViolet',
						'TSRainbowCyan'
					}
				}
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
		config = function()
			require("nvim-autopairs").setup {}
		end
	},
}
