-- depends on typescript.lua

return {
  -- treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        'astro',
        'css'
      }
    }
  },

  -- lsp
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        'astro'
      },
    },
  },

  -- format
  {
  'stevearc/conform.nvim',
    opts = function(_, opts)
      opts.formatters_by_ft.astro = { "prettier" }
    end,
  },
}
