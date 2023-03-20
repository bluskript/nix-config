return {
	["neovim/nvim-lspconfig"] = {
		config = function()
			require("plugins.configs.lspconfig")
			require("custom.plugins.lspconfig")
		end,
	},

	["nvim-telescope/telescope.nvim"] = {
		override_options = {
			pickers = {
				find_files = {
					mappings = {
						i = {
							[".."] = function()
								vim.cmd("cd ..")
								local title = require("plenary.path"):new(vim.loop.cwd()):shorten()
								require("telescope.builtin").find_files({ prompt_title = title })
							end,
							["//"] = function()
								local dir = vim.fn.system({ "git", "rev-parse", "--show-toplevel" })
								if vim.v.shell_error == 0 then
									vim.cmd("cd " .. dir)
								end
								local title = require("plenary.path"):new(vim.loop.cwd()):shorten()
								require("telescope.builtin").find_files({ prompt_title = title })
							end,
						},
					},
				},
			},
		},
	},

	["nvim-treesitter/nvim-treesitter"] = {
		override_options = {
			ensure_installed = {
				"hcl",
				"lua",
				"nix",
				"vim",
				"yaml",
			},
		},
	},

	["NvChad/ui"] = {
		override_options = {
			tabufline = {
				overriden_modules = function()
					return {
						buttons = function()
							return ""
						end,
					}
				end,
			},
		},
	},

	["lewis6991/impatient.nvim"] = false,
	["williamboman/mason.nvim"] = false,

	["jose-elias-alvarez/null-ls.nvim"] = {
		after = "nvim-lspconfig",
		config = function()
			require("custom.plugins.null-ls")
		end,
	},

	["sindrets/diffview.nvim"] = {
		requires = "nvim-lua/plenary.nvim",
		after = "plenary.nvim",
	},
	["TimUntersberger/neogit"] = {
		cmd = {
			"Neogit",
		},
		requires = "nvim-lua/plenary.nvim",
		config = function()
			require("neogit").setup({
				disable_commit_confirmation = true,
				use_magit_keybindings = true,
				signs = {
					section = { "", "" },
					item = { "", "" },
					hunk = { "", "" },
				},
				integrations = {
					diffview = true,
				},
			})
		end,
	},

	["folke/which-key.nvim"] = { disable = false },

	["nvim-orgmode/orgmode"] = {
		after = "nvim-treesitter",
		config = function()
			-- Load custom tree-sitter grammar for org filetype
			require("orgmode").setup_ts_grammar()

			-- Tree-sitter configuration
			require("nvim-treesitter.configs").setup({
				-- If TS highlights are not enabled at all, or disabled via `disable` prop, highlighting will fallback to default Vim syntax highlighting
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = { "org" }, -- Required for spellcheck, some LaTex highlights and code block highlights that do not have ts grammar
				},
				ensure_installed = { "org" }, -- Or run :TSUpdate org
			})
			require("orgmode").setup({})
		end,
	},
}