local home = vim.fn.expand("$HOME")
local leet_arg = "leetcode.nvim"

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

return {
	{
		"abecodes/tabout.nvim",
		lazy = false,
		config = function()
			require("tabout").setup({
				tabkey = "<Tab>",         -- key to trigger tabout, set to an empty string to disable
				backwards_tabkey = "<S-Tab>", -- key to trigger backwards tabout, set to an empty string to disable
				act_as_tab = true,        -- shift content if tab out is not possible
				act_as_shift_tab = true, -- reverse shift content if tab out is not possible (if your keyboard/terminal supports <S-Tab>)
				default_tab = "<C-t>",    -- shift default action (only at the beginning of a line, otherwise <TAB> is used)
				default_shift_tab = "<C-d>", -- reverse shift default action,
				enable_backwards = true,  -- well ...
				completion = false,       -- if the tabkey is used in a completion pum
				tabouts = {
					{ open = "'", close = "'" },
					{ open = '"', close = '"' },
					{ open = "`", close = "`" },
					{ open = "(", close = ")" },
					{ open = "[", close = "]" },
					{ open = "{", close = "}" },
				},
				ignore_beginning = true, --[[ if the cursor is at the beginning of a filled element it will rather tab out than shift the content ]]
				exclude = {}, -- tabout will ignore these filetypes
			})
		end,
		requires = {
			"nvim-treesitter/nvim-treesitter",
			"L3MON4D3/LuaSnip",
			"hrsh7th/nvim-cmp",
		},
		opt = true,            -- Set this to true if the plugin is optional
		event = "InsertCharPre", -- Set the event to 'InsertCharPre' for better compatibility
		priority = 1000,
	},
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {
			messages = {
				view = "mini",
			},
		},
		dependencies = {
			-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
			"MunifTanjim/nui.nvim",
			-- OPTIONAL:
			--   `nvim-notify` is only needed, if you want to use the notification view.
			--   If not available, we use `mini` as the fallback
			"rcarriga/nvim-notify",
		},
	},
	{
		"rcarriga/nvim-notify",
		opts = {
			background_colour = "#000000",
		},
	},
	{
		"direnv/direnv.vim",
	},
	{
		"bluskript/tui-nvim",
		opts = {
			y = 0.1,
			x = 0.1,
			height = 0.5,
		},
		keys = {
			{
				"<leader>j",
				function()
					require("tui-nvim"):new({
						cmd = "joshuto --file-chooser --output-file /tmp/tui-nvim "
								.. vim.fn.fnameescape(vim.fn.expand("%:p:h")),
						-- Read and open files from '/tmp/tui-nvim'
						temp = "/tmp/tui-nvim",
					})
				end,
			},
		},
	},
	-- {
	-- 	"andweeb/presence.nvim",
	-- 	opts = {
	-- 		main_image = "file",
	-- 		neovim_image_text = "menthol illness",
	-- 	},
	-- },
	{ "RRethy/nvim-base16" },
	{ "xiyaowong/transparent.nvim", opts = {} },
	{
		"L3MON4D3/LuaSnip",
		dependencies = {
			"rafamadriz/friendly-snippets",
		},
		version = "v2.*",
		build = "make install_jsregexp",
		opts = {},
		init = function()
			require("luasnip.loaders.from_vscode").lazy_load()
		end,
	},
	{ "rafamadriz/friendly-snippets" },
	{
		"chrisgrieser/nvim-spider",
		opts = {
			skipInsignificantPunctuation = false,
		},
		keys = {
			{
				"e",
				"<cmd>lua require('spider').motion('e')<CR>",
				mode = { "n", "o", "x" },
			},
			{
				"q",
				"<cmd>lua require('spider').motion('w')<CR>",
				mode = { "n", "o", "x" },
			},
			{
				"Q",
				"<cmd>lua require('spider').motion('b')<CR>",
				mode = { "n", "o", "x" },
			},
		},
	},
	{
		"chrisgrieser/nvim-various-textobjs",
		lazy = false,
		opts = {
			useDefaultKeymaps = true,
			disabledKeymaps = {
				"gc",
			},
		},
	},
	{
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim",      -- required
			"nvim-telescope/telescope.nvim", -- optional
			"sindrets/diffview.nvim",     -- optional
			"ibhagwan/fzf-lua",           -- optional
		},
		cmd = "Neogit",
		config = true,
	},
	{ "lewis6991/gitsigns.nvim",     opts = {} },
	{
		"mg979/vim-visual-multi",
	},
	{
		"elkowar/yuck.vim",
	},
	{
		"nvim-lualine/lualine.nvim",
		opts = {
			options = {
				symbols = {
					modified = " ●", -- Text to show when the buffer is modified
					alternate_file = "#", -- Text to show to identify the alternate file
					directory = "", -- Text to show when the buffer is a directory
				},
			},
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
		lazy = true,
		keys = {
			{ "<leader>ff", "<cmd>Telescope find_files<CR>" },
			{ "<leader>fg", "<cmd>Telescope live_grep<CR>" },
			{ "<leader>fh", "<cmd>Telescope oldfiles<CR>" },
			{ "<leader>sk", "<cmd>Telescope keymaps<CR>" },
			{ "<leader>r",  "<cmd>Telescope buffers<CR>" },
		},
		init = function()
			require("telescope").setup({
				defaults = vim.tbl_extend("force", require("telescope.themes").get_dropdown(), {}),
				pickers = {
					oldfiles = {
						cwd_only = true,
					},
				},
			})
		end,
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
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		requires = { "nvim-lua/plenary.nvim" },
		config = function(_, opts)
			local harpoon = require("harpoon")
			harpoon:setup()

			vim.keymap.set("n", "<C-f>", function()
				harpoon.ui:toggle_quick_menu(harpoon:list())
			end)

			vim.keymap.set("n", "<leader>m", function()
				harpoon:list():append()
			end)

			vim.keymap.set("n", "<leader>1", function()
				harpoon:list():select(1)
			end)
			vim.keymap.set("n", "<leader>2", function()
				harpoon:list():select(2)
			end)
			vim.keymap.set("n", "<leader>3", function()
				harpoon:list():select(3)
			end)
			vim.keymap.set("n", "<leader>4", function()
				harpoon:list():select(4)
			end)
		end,
	},
	{
		"kylechui/nvim-surround",
		event = "VeryLazy",
		opts = {
			enable = true,
			mode = "topline",
			surrounds = {
				["y"] = {
					add = function()
						local result = require("nvim-surround.config").get_input("Enter the type name: ")
						if result then
							return { { result .. "<" }, { ">" } }
						end
					end,
					find = function()
						return require("nvim-surround.config").get_selection({
							pattern = "[^=%s%(%)]+%b<>",
						})
					end,
					delete = "^(.-<)().-(>)()$",
					change = {
						target = "^.-([%w_]+)()<.->()()$",
						replacement = function()
							local result = require("nvim-surround.config").get_input("Enter new type replacement: ")
							if result then
								return { { result }, { "" } }
							end
						end,
					},
				},
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
		event = "VeryLazy",
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
		opts = {
			animation = false,
		},
		keys = {
			{ "<Tab>",     "<cmd>BufferNext<CR>" },
			{ "<S-Tab>",   "<cmd>BufferPrev<CR>" },
			{ "<leader>x", "<cmd>BufferClose<CR>" },
		},
	},
	{
		"lukas-reineke/indent-blankline.nvim",
	},
	{
		"windwp/nvim-autopairs",
		event = "VeryLazy",
		opts = {
			check_ts = true,
		},
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
		lazy = leet_arg ~= vim.fn.argv()[1],
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-telescope/telescope.nvim",
			"nvim-lua/plenary.nvim", -- required by telescope
			"MunifTanjim/nui.nvim",

			-- optional
			-- "rcarriga/nvim-notify",
			"nvim-tree/nvim-web-devicons",
		},
		opts = {
			arg = leet_arg,
		},
	},
	{
		"scalameta/nvim-metals",
		ft = { "scala", "sbt", "java" },
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
}
