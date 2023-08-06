local home = vim.fn.expand("$HOME")

return {
	{
		"nvim-lualine/lualine.nvim",
		opts = {},
	},
	{
		"sindrets/winshift.nvim",
		keys = {
			{ "<C-W><C-M>", "<cmd>WinShift<CR>" },
			{ "<C-W>m",     "<cmd>WinShift<CR>" },
			{ "<C-W>X",     "<cmd>WinShift swap<CR>" },
		},
	},
	{
		"sindrets/diffview.nvim",
		event = "VeryLazy",
		keys = {
			{ "<leader>dp", "<cmd>DiffviewOpen<CR>" },
			{ "<leader>dx", "<cmd>DiffviewClose<CR>" },
		},
		config = function()
			local actions = require("diffview.actions")
			require("diffview").setup({
				enhanced_diff_hl = true,
				keymaps = {
					file_panel = {
						{
							"n",
							"j",
							actions.select_next_entry,
							{ desc = "alias for tab" },
						},
						{
							"n",
							"k",
							actions.select_prev_entry,
							{ desc = "alias for shift-tab" },
						},
					},
				},
			})
		end,
	},
	{
		"jackMort/ChatGPT.nvim",
		event = "VeryLazy",
		keys = {
			{ "<leader>p", "<cmd>ChatGPTCompleteCode<CR>" },
		},
		opts = {
			api_key_cmd = "cat " .. home .. "/.config/shell_gpt/woozy",
		},
		dependencies = {
			"MunifTanjim/nui.nvim",
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
		},
	},
	{
		"RaafatTurki/hex.nvim",
		opts = {},
	},
	{
		"cbochs/portal.nvim",
		keys = {
			{ "<leader>o", "<cmd>Portal jumplist backward<cr>" },
			{ "<leader>i", "<cmd>Portal jumplist forward<cr>" },
		},
	},
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		cmd = "Telescope",
		keys = {
			{ "<leader>ff", "<cmd>Telescope find_files<CR>" },
			{ "<leader>fg", "<cmd>Telescope live_grep<CR>" },
			{ "<leader>sk", "<cmd>Telescope keymaps<CR>" },
		},
	},
	{
		"NvChad/nvim-colorizer.lua",
		init = function()
			require("colorizer").setup()
		end,
	},
	{
		"nmac427/guess-indent.nvim",
		opts = {},
	},
	{
		"folke/twilight.nvim",
		opts = {
			dimming = {
				alpha = 0.5,
			},
		},
	},
	{
		"ThePrimeagen/harpoon",
		keys = {
			{
				"<S-m>",
				function()
					require("harpoon.mark").add_file()
				end,
			},
			{
				"<C-m>",
				function()
					require("harpoon.ui").toggle_quick_menu()
				end,
			},
		},
	},
	{
		"kylechui/nvim-surround",
		event = "VeryLazy",
		opts = {},
	},
	{
		"RRethy/vim-illuminate",
		event = "VeryLazy",
	},
	{
		"ray-x/lsp_signature.nvim",
		-- event = "VeryLazy",
		opts = {
			bind = true,
			handler_opts = {
				border = "rounded",
			},
		},
	},
	{
		"weilbith/nvim-code-action-menu",
		event = "VeryLazy",
		cmd = "CodeActionMenu",
		keys = {
			{ "<leader>c", "<cmd>CodeActionMenu<CR>" },
		},
	},
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		opts = {
			open_mapping = [[<A-\>]],
		},
	},
	{
		"jubnzv/virtual-types.nvim",
	},
	{
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
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
			{ ";", "<cmd>HopWord<cr>" },
			{ "'", "<cmd>HopLineStart<cr>" },
		},
		config = function()
			require("hop").setup()
		end,
	},
	{
		"romgrk/barbar.nvim",
		lazy = false,
		dependencies = "nvim-tree/nvim-web-devicons",
		init = function()
			vim.g.barbar_auto_setup = false
		end,
		opts = {},
		keys = {
			{ "<Tab>",     "<cmd>BufferNext<CR>" },
			{ "<S-Tab>",   "<cmd>BufferPrev<CR>" },
			{ "<leader>x", "<cmd>BufferClose<CR>" },
		},
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
		opts = {},
	},
}
