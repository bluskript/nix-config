local M = {}

M.ui = {
  theme = "rosepine",
}

M.mappings = {
  general = {
    n = {
      ["<leader>fq"] = { "<cmd> :wq <CR>", "Save and quit" },
      ["<leader>fs"] = { "<cmd> :update <CR>", "Save" },
      ["<leader>fS"] = { "<cmd> :execute ':silent w !sudo tee % > /dev/null' | :edit! <CR>", "Sudo save" },
      ["<leader>gg"] = { "<cmd> :Neogit <CR>", "Neogit" },
      ["<leader><leader>"] = { "<cmd> :Telescope custom find <CR>", "Find" },
    },
  },
}

M.nvimtree = {
  git = {
    enable = true,
  },

  renderer = {
    highlight_git = true,
    icons = {
      show = {
        git = true,
      },
    },
    view = {
      adaptive_size = false,
      width = 30,
      preserve_window_proportions = true,
    },
  },
}

M.plugins = require "custom.plugins"

return M
