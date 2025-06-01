return {
  -- treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        'nix'
      }
    }
  },

  -- lsp
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        'nil_ls'
      }
    },
  },

  -- format
  {
    'stevearc/conform.nvim',
    optional = true,
    opts = function(_, opts)
      opts.formatters_by_ft.nix = {
        'nixfmt'
      }
    end
  },

}
