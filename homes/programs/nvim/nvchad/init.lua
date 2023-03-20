vim.opt.commentstring = "# %s"
vim.opt.relativenumber = true
vim.api.nvim_create_autocmd({"FileType"}, {
  pattern = {"gitcommit", "NeogitCommitMessage"},
  command = "exec 'norm gg' | startinsert!",
})