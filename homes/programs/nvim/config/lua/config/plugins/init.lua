local home = vim.fn.expand("$HOME")

return {
	{ "LhKipp/nvim-nu",             opts = {} },
	{ "RRethy/nvim-base16" },
	{ "xiyaowong/transparent.nvim", opts = {} },
	{
		"chrisgrieser/nvim-various-textobjs",
		lazy = false,
		opts = { useDefaultKeymaps = true },
	},
	{
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim",      -- required
			"nvim-telescope/telescope.nvim", -- optional
			"sindrets/diffview.nvim",     -- optional
			"ibhagwan/fzf-lua",           -- optional
		},
		config = true,
	},
	{
		"j-hui/fidget.nvim",
		tag = "legacy",
		event = "LspAttach",
		opts = {},
	},
	{
		"mg979/vim-visual-multi",
		event = "VeryLazy",
	},
	{
		"elkowar/yuck.vim",
	},
	{
		"nvim-lualine/lualine.nvim",
		opts = {},
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
	-- {
	-- 	"jackMort/ChatGPT.nvim",
	-- 	event = "VeryLazy",
	-- 	keys = {
	-- 		{ "<leader>p", "<cmd>ChatGPTCompleteCode<CR>" },
	-- 	},
	-- 	opts = {
	-- 		api_key_cmd = "cat " .. home .. "/.config/shell_gpt/woozy",
	-- 	},
	-- 	dependencies = {
	-- 		"MunifTanjim/nui.nvim",
	-- 		"nvim-lua/plenary.nvim",
	-- 		"nvim-telescope/telescope.nvim",
	-- 	},
	-- },
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
			{ "<leader>fh", "<cmd>Telescope oldfiles<CR>" },
			{ "<leader>sk", "<cmd>Telescope keymaps<CR>" },
		},
	},
	{
		"NvChad/nvim-colorizer.lua",
		init = function()
			require("colorizer").setup({})
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
	-- {
	-- 	"ThePrimeagen/harpoon",
	-- 	keys = {
	-- 		{
	-- 			"<S-m>",
	-- 			function()
	-- 				require("harpoon.mark").add_file()
	-- 			end,
	-- 		},
	-- 		{
	-- 			"<C-m>",
	-- 			function()
	-- 				require("harpoon.ui").toggle_quick_menu()
	-- 			end,
	-- 		},
	-- 	},
	-- },
	{
		"kylechui/nvim-surround",
		event = "VeryLazy",
		opts = {
			enable = true,
			mode = "topline",
		},
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
		init = function()
			require("Comment").setup({
				pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
			})
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
		event = "VeryLazy",
	},
	{
		"meatballs/notebook.nvim",
		opts = {},
		event = "VeryLazy",
	},
	{
		"kawre/leetcode.nvim",
		build = ":TSUpdate html",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-telescope/telescope.nvim",
			"nvim-lua/plenary.nvim", -- required by telescope
			"MunifTanjim/nui.nvim",

			-- optional
			"rcarriga/nvim-notify",
			"nvim-tree/nvim-web-devicons",
		},
		opts = {},
	},
	{
		"scalameta/nvim-metals",
		dependencies = { "nvim-lua/plenary.nvim" },
		init = function()
			local metals_config = require("metals").bare_config()
			metals_config.settings = {
				showImplicitArguments = true,
				useGlobalExecutable = true,
			}

			metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities()

			local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
			vim.api.nvim_create_autocmd("FileType", {
				-- NOTE: You may or may not want java included here. You will need it if you
				-- want basic Java support but it may also conflict if you are using
				-- something like nvim-jdtls which also works on a java filetype autocmd.
				pattern = { "scala", "sbt" },
				callback = function()
					require("metals").initialize_or_attach(metals_config)
				end,
				group = nvim_metals_group,
			})
		end,
	},
	{
		"rcarriga/nvim-notify",
		opts = {
			background_colour = "#000000",
		},
	},
}
