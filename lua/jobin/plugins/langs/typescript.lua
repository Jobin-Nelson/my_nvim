return {
  -- lsp
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        'vtsls'
      }
    },
  },
  {
    'yioneko/nvim-vtsls',
    ft = {
      'typescript',
      'javascript',
      'typescriptreact',
      'javascriptreact'
    },
  },

  -- format
  {
  'stevearc/conform.nvim',
    opts = function(_, opts)
      opts.formatters_by_ft.typescript = { "prettier" }
      opts.formatters_by_ft.typescriptreact = { "prettier" }
    end,
  },
}
