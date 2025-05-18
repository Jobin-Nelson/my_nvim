return {
  -- treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = vim.list_extend(opts.ensure_installed, {
        'rust',
        'ron',
      })
    end
  },

  -- lsp
  {
    'mrcjkb/rustaceanvim',
    ft = 'rust',
    dependencies = 'nvim-neotest/neotest',
    version = '^5', -- Recommended
    init = function()
      vim.g.rustaceanvim = {
        tools = {
          hover_actions = {
            replace_builtin_hover = false,
          }
        },
      }
    end,
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('Rustaceanvim-Lsp-Attach-KeyMaps', { clear = true }),
        pattern = 'rust',
        callback = function(args)
          local nmap = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = args.buf, desc = desc })
          end
          nmap('<leader>la', function() vim.cmd.RustLsp('codeAction') end, 'Lsp code Action')
          nmap('<leader>dRr', function() vim.cmd.RustLsp('runnables') end, 'Rust Debuggables')
          nmap('<leader>dRd', function() vim.cmd.RustLsp('debuggables') end, 'Rust Debuggables')
          nmap('<leader>dRt', function() vim.cmd.RustLsp('testables') end, 'Rust Testables')
          nmap('<leader>lf', function() vim.cmd.RustFmt() end, 'Rust Format')
          vim.keymap.set('v', '<leader>lf', function() vim.cmd.RustFmtRange() end,
            { buffer = args.buf, desc = 'Rust Format Range' })
        end
      })
    end
  },

  -- test
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = {
      "mrcjkb/rustaceanvim",
    },
    opts = function(_, opts)
      local adapters = {
        require('rustaceanvim.neotest')
      }
      opts.adapters = vim.tbl_extend('keep', opts.adapters, adapters)
    end,
  },
}
