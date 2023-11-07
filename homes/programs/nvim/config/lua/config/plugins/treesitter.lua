local disable = function(lang, buf)
	local max_filesize = 20 * 1024 -- 20 KB
	local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
	if ok and stats and stats.size > max_filesize then
		return true
	end
end

return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			---@diagnostic disable-next-line: missing-fields
			require("nvim-treesitter.configs").setup({
				auto_install = true,
				ensure_installed = "all",
				sync_install = true,
				ignore_install = {},
				highlight = {
					enable = true,
					disable = disable,
				},
				indent = { enable = true, disable = disable },
				incremental_selection = {
					enable = true,
					disable = disable,
					keymaps = {
						init_selection = "gnn",
						node_incremental = "grn",
						scope_incremental = "grc",
						node_decremental = "grm",
					},
				},
				rainbow = {
					disable = disable,
				},
				illuminate = {
					disable = disable,
				},
				autotag = {
					disable = disable,
				},
			})
		end,
	},
	-- {
	-- 	"HiPhish/rainbow-delimiters.nvim",
	-- 	config = function()
	-- 		local rainbow_delimiters = require("rainbow-delimiters")
	-- 		require("rainbow-delimiters.setup")({
	-- 			disable = disable,
	-- 			strategy = {
	-- 				[""] = rainbow_delimiters.strategy["global"],
	-- 				vim = rainbow_delimiters.strategy["local"],
	-- 			},
	-- 			query = {
	-- 				[""] = "rainbow-delimiters",
	-- 				lua = "rainbow-blocks",
	-- 			},
	-- 			highlight = {
	-- 				"RainbowDelimiterRed",
	-- 				"RainbowDelimiterYellow",
	-- 				"RainbowDelimiterBlue",
	-- 				"RainbowDelimiterOrange",
	-- 				"RainbowDelimiterGreen",
	-- 				"RainbowDelimiterViolet",
	-- 				"RainbowDelimiterCyan",
	-- 			},
	-- 		})
	-- 	end,
	-- },
	{
		"RRethy/vim-illuminate",
		event = "VeryLazy",
		init = function()
			vim.cmd("highlight! link IlluminatedWordText Visual")
			vim.cmd("highlight! link IlluminatedWordRead Visual")
			vim.cmd("highlight! link IlluminatedWordWrite Visual")
		end,
	},
	{
		"windwp/nvim-ts-autotag",
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		opts = {
			max_lines = 2,
			multiline_threshold = 2,
			on_attach = function(buf)
				return disable("bleh", buf)
			end,
		},
		init = function()
			vim.cmd("hi TreesitterContext guifg=Grey")
		end,
	},
	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		opts = {},
	},
}
