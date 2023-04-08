local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('config.mappings')


require("lazy").setup({
  {
    "folke/which-key.nvim",
    lazy = true,
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
  },
  {
    "phaazon/hop.nvim",
    branch = "v2",
    keys = {
      { "f", "<cmd>HopWord<cr>" },
      { "F", "<cmd>HopLineStart<cr>" },
    },
    config = function()
      require('hop').setup()
    end
  },
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
    },
    config = function()
      local cmp = require('cmp')
      cmp.setup({
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
        })
      }, {
        { name = 'buffer' }
      })
    end,
  }
}, {})

require('config.options')
