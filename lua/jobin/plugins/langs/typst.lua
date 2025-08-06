return {
  -- treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        'typst'
      }
    }
  },

  -- lsp
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        'tinymist'
      }
    },
  },

  -- previewer
  {
    'chomosuke/typst-preview.nvim',
    ft = 'typst',
    version = '1.*',
    opts = {},
  }
}
