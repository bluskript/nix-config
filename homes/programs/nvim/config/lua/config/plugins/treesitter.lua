return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter.configs").setup({
			-- ensure_installed = "all",
			highlight = {
				enable = true,
				-- disable = function(lang, buf)
				-- 	local max_filesize = 10 * 1024 -- 10 KB
				-- 	local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
				-- 	if ok and stats and stats.size > max_filesize then
				-- 		return true
				-- 	end
				-- end,
			},
			indent = { enable = true },
			autotag = {
				enable = true,
			},
			rainbow = {
				enable = true,
				extended_mode = true,
				max_file_lines = nil,
				hlgroups = {
					"TSRainbowYellow",
					"TSRainbowBlue",
					"TSRainbowOrange",
					"TSRainbowGreen",
					"TSRainbowViolet",
					"TSRainbowCyan",
				},
			},
		})
	end,
}
