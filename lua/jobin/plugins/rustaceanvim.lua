vim.g.rustaceanvim = {
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
      nmap('<leader>lf',function() vim.cmd.RustFmt() end, 'Rust Format')
      vim.keymap.set('v', '<leader>lf', function() vim.cmd.RustFmtRange() end, { buffer = bufnr, desc = 'Rust Format Range' })

      nmap('<leader>lr', vim.lsp.buf.rename, 'Lsp Rename')
      nmap('gd', vim.lsp.buf.definition, 'Goto Definition')
      nmap('gr', require('telescope.builtin').lsp_references, 'Goto References')
      nmap('gI', vim.lsp.buf.implementation, 'Goto Implementation')
      nmap('gl', vim.diagnostic.open_float, 'Open diagnostic')
      -- nmap(']d', vim.diagnostic.goto_next, 'Next diagnostic')
      -- nmap('[d', vim.diagnostic.goto_prev, 'Previous diagnostic')
      nmap('<leader>lt', vim.lsp.buf.type_definition, 'Goto Type definition')
      nmap('<leader>lq', vim.diagnostic.setloclist, 'Set diagnostic quickfix')
      nmap('<leader>ld', require('telescope.builtin').diagnostics, 'Open diagnostic list')
      nmap('<leader>ls', require('telescope.builtin').lsp_document_symbols, 'Lsp Document Symbols')
      nmap('<leader>lS', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Lsp Workspace Symbols')
      nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
      nmap('gD', vim.lsp.buf.declaration, 'Goto Declaration')
      nmap('<leader>lwa', vim.lsp.buf.add_workspace_folder, 'Lsp Workspace Add folder')
      nmap('<leader>lwr', vim.lsp.buf.remove_workspace_folder, 'Lsp Workspace Remove folder')
      nmap('<leader>lwl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end, 'Lsp Workspace List folders')
    end,
    cmd = { "rustup", "run", "stable", "rust-analyzer" },
  },
}

return {
  'mrcjkb/rustaceanvim',
  ft = 'rust',
  version = '^4', -- Recommended
}
