return {
  -- lsp
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        'pyright',
        'ruff',
      }
    },
  },

  -- format
  {
    'stevearc/conform.nvim',
    opts = function(_, opts)
      opts.formatters_by_ft.python = {
        'ruff_format',
        'ruff_organize_imports'
      }
    end
  },

  -- dap
  {
    "mfussenegger/nvim-dap",
    optional = true,
    dependencies = {
      "mfussenegger/nvim-dap-python",
      keys = {
        { "<leader>dPt", function() require('dap-python').test_method() end, desc = "Debug Method", ft = "python" },
        { "<leader>dPc", function() require('dap-python').test_class() end,  desc = "Debug Class",  ft = "python" },
      },
      config = function()
        require("dap-python").setup("uv")
      end,
    },
  },

  -- test
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = {
      "nvim-neotest/neotest-python",
    },
    opts = function(_, opts)
      opts.adapters = vim.tbl_extend('keep', opts.adapters, {
        require('neotest-python')
      })
    end,
  }
}
