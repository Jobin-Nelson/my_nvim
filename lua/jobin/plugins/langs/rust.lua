return {
  -- treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        'rust',
        'ron',
      }
    }
  },

  -- lsp
  -- {
  --   'neovim/nvim-lspconfig',
  --   opts = {
  --     servers = {
  --       'bacon_ls'
  --     }
  --   },
  -- },
  {
    'mrcjkb/rustaceanvim',
    ft = { 'rust' },
    version = '^6', -- Recommended
    init = function()
      vim.g.rustaceanvim = {
        tools = {
          hover_actions = {
            replace_builtin_hover = false,
          }
        },
        server = {
          on_attach = function(_, bufnr)
            local map = function(mode, keys, func, desc)
              vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = desc })
            end
            map('n', '<leader>lra', function() vim.cmd.RustLsp('codeAction') end, 'Lsp code Action')
            map('n', '<leader>dRr', function() vim.cmd.RustLsp('runnables') end, 'Rust Debuggables')
            map('n', '<leader>dRd', function() vim.cmd.RustLsp('debuggables') end, 'Rust Debuggables')
            map('n', '<leader>dRt', function() vim.cmd.RustLsp('testables') end, 'Rust Testables')
            map('n', '<leader>lf', function() vim.cmd.RustFmt() end, 'Rust Format')
            map('v', '<leader>lf', function() vim.cmd.RustFmtRange() end, 'Rust Format Range')
          end,
          default_settings = {
            -- rust-analyzer language server configuration
            ["rust-analyzer"] = {
              cargo = {
                allFeatures = true,
                loadOutDirsFromCheck = true,
                buildScripts = {
                  enable = true,
                },
              },
              -- Add clippy lints for Rust if using rust-analyzer
              checkOnSave = { enable = true },
              -- Enable diagnostics if using rust-analyzer
              diagnostics = { enable = true },
              -- procMacro = {
              --   enable = true,
              --   ignored = {
              --     ["async-trait"] = { "async_trait" },
              --     ["napi-derive"] = { "napi" },
              --     ["async-recursion"] = { "async_recursion" },
              --   },
              -- },
              files = {
                excludeDirs = {
                  ".direnv",
                  ".git",
                  ".github",
                  ".gitlab",
                  "bin",
                  "node_modules",
                  "target",
                  "venv",
                  ".venv",
                },
              },
            },
          },
        }
      }
    end,
  },

  -- test
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = {
      "mrcjkb/rustaceanvim",
    },
    opts = function(_, opts)
      opts.adapters = vim.tbl_extend('keep', opts.adapters, {
        require('rustaceanvim.neotest')
      })
    end,
  },

  -- others
  {
    "Saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    opts = {
      completion = {
        crates = {
          enabled = true,
        },
      },
      lsp = {
        enabled = true,
        actions = true,
        completion = true,
        hover = true,
      },
      popup = {
        border = "rounded",
      }
    },
  }
}
