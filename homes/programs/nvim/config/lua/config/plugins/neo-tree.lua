local is_netrw = vim.bo.filetype == "netrw"

return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
		"MunifTanjim/nui.nvim",
	},
	keys = {
		{ "<C-l>", "<cmd>Neotree float toggle reveal<CR>" },
	},
	lazy = is_netrw,
	opts = {
		filesystem = {
			hijack_netrw_behavior = "open_current"
		},
		window = {
			mappings = {
				["<space>"] = {
					"toggle_node",
					nowait = true,
				},
				["l"] = "open",
			},
		},
	},
}
