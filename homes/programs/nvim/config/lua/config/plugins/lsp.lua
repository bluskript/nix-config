return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		{
			"b0o/schemastore.nvim",
		},
	},
	config = function()
		local tb = require("telescope.builtin")
		vim.lsp.handlers["callHierarchy/incomingCalls"] = tb.lsp_incoming_calls
		vim.lsp.handlers["callHierarchy/outgoingCalls"] = tb.lsp_outgoing_calls
		vim.lsp.handlers["textDocument/references"] = tb.lsp_references
		vim.lsp.handlers["textDocument/typeDefinition"] = tb.lsp_type_definitions
		vim.lsp.handlers["textDocument/implementation"] = tb.lsp_implementations
		vim.lsp.handlers["textDocument/documentSymbol"] = tb.lsp_document_symbols
		vim.lsp.handlers["workspace/symbol"] = tb.lsp_workspace_symbols

		local lspconfig = require("lspconfig")
		local capabilities = require("cmp_nvim_lsp").default_capabilities()
		capabilities.offsetEncoding = { "utf-8" }
		capabilities.textDocument.foldingRange = {
			dynamicRegistration = false,
			lineFoldingOnly = true
		}
		-- capabilities.textDocument.completion.completionItem.snippetSupport = false

		-- common options that all LSPs should have
		local common_options = {
			on_attach = require("virtualtypes").onattach,
			-- on_list = on_list,
			capabilities = capabilities,
		}

		-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
		local servers = {
			"tsserver",
			"nil_ls",
			"yamlls",
			"terraform_lsp",
			"dockerls",
			"zls",
			"clangd",
			"cssls",
			"html",
			"eslint",
			"gopls",
			"nushell",
		}

		---@generic T1: table
		---@param tbl T1
		---@return table
		local extend_config = function(tbl)
			return vim.tbl_deep_extend("force", tbl, common_options)
		end

		for _, lsp in ipairs(servers) do
			lspconfig[lsp].setup(common_options)
		end

		lspconfig.hls.setup(extend_config({
			filetypes = { "haskell", "lhaskell", "cabal" },
		}))

		lspconfig.rust_analyzer.setup(extend_config({
			settings = {
				["rust-analyzer"] = {
					checkOnSave = {
						allFeatures = true,
					},
					cargo = {
						allFeatures = true,
					},
				},
			},
		}))

		lspconfig.pyright.setup(extend_config({
			settings = {
				python = {
					analysis = {
						autoSearchPaths = true,
						extraPaths = { vim.fn.getcwd() .. "/common/", vim.fn.getcwd() .. "/ML/common/" },
					},
				},
			},
		}))

		lspconfig.lua_ls.setup(extend_config({
			settings = {
				Lua = {
					runtime = {
						-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
						version = "LuaJIT",
					},
					diagnostics = {
						-- Get the language server to recognize the `vim` global
						globals = { "vim" },
					},
					workspace = {
						-- Make the server aware of Neovim runtime files
						library = vim.api.nvim_get_runtime_file("", true),
					},
					-- Do not send telemetry data containing a randomized but unique identifier
					telemetry = {
						enable = false,
					},
				},
			},
		}))

		lspconfig.jsonls.setup(extend_config({
			settings = {
				json = {
					schemas = require("schemastore").json.schemas(),
					validate = { enable = true },
				},
			},
		}))

		lspconfig.yamlls.setup(extend_config({
			settings = {
				yaml = {
					schemaStore = {
						-- You must disable built-in schemaStore support if you want to use
						-- this plugin and its advanced options like `ignore`.
						enable = false,
						-- Avoid TypeError: Cannot read properties of undefined (reading 'length')
						url = "",
					},
					schemas = require("schemastore").yaml.schemas(),
				},
			},
		}))

		vim.api.nvim_exec(
			[[
autocmd FileType qf nnoremap <buffer> <CR> <CR>:cclose<CR>
    ]],
			false
		)
		-- vim.api.nvim_create_autocmd("BufWritePre", {
		-- 	callback = function()
		-- 		vim.lsp.buf.format({ async = true })
		-- 	end,
		-- })
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				-- local gotopreview = require("goto-preview")
				-- Enable completion triggered by <c-x><c-o>
				vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

				-- Buffer local mappings.
				-- See `:help vim.lsp.*` for documentation on any of the below functions
				local opts = { buffer = ev.buf }
				vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
				vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
				vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
				vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)

				-- vim.keymap.set("n", "gD", gotopreview.goto_preview_type_definition, opts)
				-- vim.keymap.set("n", "gd", gotopreview.goto_preview_definition, opts)
				vim.api.nvim_set_keymap(
					"n",
					"gD",
					"<cmd>lua vim.lsp.buf.declaration()<CR>",
					{ noremap = true, silent = true }
				)
				vim.api.nvim_set_keymap(
					"n",
					"gd",
					"<cmd>lua vim.lsp.buf.definition()<CR>",
					{ noremap = true, silent = true }
				)
				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
				vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
				vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
				vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
				vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
				vim.keymap.set("n", "<leader>wl", function()
					print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
				end, opts)
				vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
				vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
				-- vim.keymap.set('n', '<leader>c', vim.lsp.buf.code_action, opts)
				vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
				vim.keymap.set("n", "<leader>fm", function()
					vim.lsp.buf.format({ async = true })
				end, opts)
			end,
		})
	end,
}
