local present, null_ls = pcall(require, "null-ls")

if not present then
	return
end

local b = null_ls.builtins

local sources = {
	-- Lua
b.formatting.stylua,

	b.formatting.prettier.with({
		prefer_local = "node_modules/.bin",
	}),

	-- Shell
	b.diagnostics.shellcheck.with({ diagnostics_format = "#{m} [#{c}]" }),
}

null_ls.setup({
	debug = true,
	sources = sources,
	on_attach = function(client)
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_create_autocmd("BufWritePost", {
				callback = function()
					vim.lsp.buf.format()
				end,
			})
		end
	end,
})
