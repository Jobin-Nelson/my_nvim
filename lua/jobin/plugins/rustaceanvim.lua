return {
  'mrcjkb/rustaceanvim',
  ft = 'rust',
  dependencies = 'nvim-neotest/neotest',
  version = '^5', -- Recommended
  config = function()
    local mason_registry = require('mason-registry')
    local codelldb = mason_registry.get_package('codelldb')
    local extension_path = codelldb:get_install_path() .. '/extension/'
    local codelldb_path = extension_path .. 'adapter/codelldb'
    local liblldb_path = extension_path .. 'lldb/lib/liblldb.dylib'
    local cfg = require('rustaceanvim.config')

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

    vim.g.rustaceanvim = {
      dap = {
        adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
      },
      tools = {
        hover_actions = {
          replace_builtin_hover = false,
        }
      },
    }

    ---@diagnostic disable-next-line: missing-fields
    require('neotest').setup({
      adapters = {
        require('rustaceanvim.neotest')
      }
    })
  end
}
