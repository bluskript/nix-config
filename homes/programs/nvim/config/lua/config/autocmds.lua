vim.api.nvim_create_autocmd("FileType", {
  pattern = { "leetcode.nvim", "markdown", "tex" },
  command = "setlocal linebreak",
})


vim.cmd([[autocmd SwapExists * let v:swapchoice = "e"]])
