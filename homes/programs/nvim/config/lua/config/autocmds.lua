vim.api.nvim_create_autocmd("FileType", {
  pattern = { "leetcode.nvim", "markdown", "tex" },
  command = "setlocal linebreak",
})
