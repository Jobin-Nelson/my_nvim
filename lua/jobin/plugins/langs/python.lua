return {
  -- lsp
  {
    'neovim/nvim-lspconfig',
    ft = 'python',
    opts = function(_, opts)
      opts = opts or { servers = {} }
      local servers = {
        'pyright',
        'ruff',
      }
      opts.servers = vim.list_extend(opts.servers or {}, servers)

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup('lsp_attach_disable_ruff_hover', { clear = true }),
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client == nil then
            return
          end
          if client.name == 'ruff' then
            -- Disable hover in favor of Pyright
            client.server_capabilities.hoverProvider = false
          end
        end,
        desc = 'LSP: Disable hover capability from Ruff',
      })

      vim.keymap.set('n', '<leader>lo', function()
        vim.lsp.buf.code_action({
          apply = true,
          context = {
            only = { 'source.organizeImports' },
            diagnostics = {},
          },
        })
      end, { buffer = true, desc = 'Organize Imports' })

      return opts
    end,
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
    opts = {
      adapters = {
        ["neotest-python"] = {
          -- Here you can specify the settings for the adapter, i.e.
          -- runner = "pytest",
          -- python = ".venv/bin/python",
        },
      },
    },
  }
}
