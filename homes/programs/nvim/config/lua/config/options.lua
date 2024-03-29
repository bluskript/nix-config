vim.o.relativenumber = true
vim.o.number = true
vim.o.cursorline = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.autoindent = "smartindent"
vim.o.clipboard = "unnamedplus"
-- vim.o.autochdir = true
vim.o.termguicolors = true
-- custom config file vim uses
vim.o.exrc = true

local set = vim.opt -- set options
set.fillchars = set.fillchars + "diff:╱"

vim.filetype.add({
  pattern = {
    ["\v.*.(vert|frag|shader|vs|fs|gs|vsh|fsh|comp)"] = "glsl",
    ["\v.*.nu"] = "nu",
  },
})
