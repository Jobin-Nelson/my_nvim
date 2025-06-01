return {
  -- treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "go", "gomod", "gowork", "gosum" } },
  },

  -- lsp
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        'gopls'
      }
    },
  },

  -- format
  {
    'stevearc/conform.nvim',
    opts = function(_, opts)
      opts.formatters_by_ft.go = {
        'goimports',
        'gofmt',
      }
    end
  },

  -- dap
  {
    "mfussenegger/nvim-dap",
    optional = true,
    dependencies = {
      {
        "leoluz/nvim-dap-go",
        opts = {},
      },
    },
  },

  -- test
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = {
      "fredrikaverpil/neotest-golang",
    },
    opts = function(_, opts)
      opts.adapters = vim.tbl_extend('keep', opts.adapters, {
        require('neotest-golang')
      })
    end,
  }
}
