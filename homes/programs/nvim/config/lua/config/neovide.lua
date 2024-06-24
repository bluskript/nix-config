vim.g.neovide_cursor_vfx_mode = "pixiedust"
vim.o.guifont = "Jetbrains_Mono,Noto_Sans_Mono_CJK_SC,Symbols_Nerd_Font_Mono,Twitter_Color_Emoji:h11:#e-subpixelantialias:#h-full"
vim.g.neovide_transparency = 0.8
vim.g.transparent_enabled = false

vim.api.nvim_set_keymap(
	"n",
	"<C-+>",
	":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1<CR>",
	{ silent = true }
)
vim.api.nvim_set_keymap(
	"n",
	"<C-->",
	":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1<CR>",
	{ silent = true }
)
vim.api.nvim_set_keymap("n", "<C-0>", ":lua vim.g.neovide_scale_factor = 1<CR>", { silent = true })

vim.keymap.set("n", "<M-s>", ":w<CR>")      -- Save
vim.keymap.set("v", "<M-c>", '"+y')         -- Copy
vim.keymap.set("n", "<M-v>", '"+P')         -- Paste normal mode
vim.keymap.set("v", "<M-v>", '"+P')         -- Paste visual mode
vim.keymap.set("c", "<M-v>", "<C-S-R>+")      -- Paste command mode
vim.keymap.set("i", "<M-v>", '<C-R>+') -- Paste insert mode

