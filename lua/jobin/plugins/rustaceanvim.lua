
return {
  'mrcjkb/rustaceanvim',
  ft = 'rust',
  version = '^5', -- Recommended
  config = function()
    local mason_registry = require('mason-registry')
    local codelldb = mason_registry.get_package('codelldb')
    local extension_path = codelldb:get_install_path() .. '/extension/'
    local codelldb_path = extension_path .. 'adapter/codelldb'
    local liblldb_path = extension_path .. 'lldb/lib/liblldb.dylib'
    local cfg = require('rustaceanvim.config')

  vim.g.rustaceanvim = {
    dap = {
      adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
    },
    tools = {
      hover_actions = {
        replace_builtin_hover = false,
      }
    },
    server = {
      on_attach = function(_, bufnr)
        local nmap = function(keys, func, desc)
          vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
        end
        nmap('<leader>la', function() vim.cmd.RustLsp('codeAction') end, 'Lsp code Action')
        nmap('<leader>dRr',function() vim.cmd.RustLsp('runnables') end, 'Rust Debuggables')
        nmap('<leader>dRd',function() vim.cmd.RustLsp('debuggables') end, 'Rust Debuggables')
        nmap('<leader>dRt',function() vim.cmd.RustLsp('testables') end, 'Rust Testables')
        nmap('<leader>lf',function() vim.cmd.RustFmt() end, 'Rust Format')
        vim.keymap.set('v', '<leader>lf', function() vim.cmd.RustFmtRange() end, { buffer = bufnr, desc = 'Rust Format Range' })

        nmap('<leader>lr', vim.lsp.buf.rename, 'Lsp Rename')
        nmap('gd', '<cmd>FzfLua lsp_definitions jump_to_single_result=true ignore_current_line=true<cr>', 'Goto [D]efinition')
        nmap('gr', '<cmd>FzfLua lsp_references jump_to_single_result=true ignore_current_line=true<cr>', 'Goto [R]eferences')
        nmap('gI', '<cmd>FzfLua lsp_implementations jump_to_single_result=true ignore_current_line=true<cr>', 'Goto [I]mplementation')
        nmap('gy', '<cmd>FzfLua lsp_typedefs jump_to_single_result=true ignore_current_line=true<cr>', 'Goto T[y]pe Definition')
        nmap('gD', vim.lsp.buf.declaration, 'Goto [D]eclaration')
        nmap(']d', vim.diagnostic.goto_next, 'Next diagnostic')
        nmap('[d', vim.diagnostic.goto_prev, 'Previous diagnostic')
        nmap('<leader>lq', vim.diagnostic.setloclist, 'Set diagnostic quickfix')
        nmap('<leader>ld', '<cmd>FzfLua diagnostics_document jump_to_single_result=true ignore_current_line=true<cr><cr>', 'Open diagnostic list')
        nmap('<leader>ls', '<cmd>FzfLua lsp_document_symbols jump_to_single_result=true ignore_current_line=true<cr><cr>', 'Lsp Document Symbols')
        nmap('<leader>lS', '<cmd>FzfLua lsp_live_workspace_symbols jump_to_single_result=true ignore_current_line=true<cr><cr>', 'Lsp Workspace Symbols')
        nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
        nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
        nmap('<leader>lwa', vim.lsp.buf.add_workspace_folder, 'Lsp Workspace Add folder')
        nmap('<leader>lwr', vim.lsp.buf.remove_workspace_folder, 'Lsp Workspace Remove folder')
        nmap('<leader>lwl', function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, 'Lsp Workspace List folders')
      end,
    },
  }
  end
}
