return {
  'nvim-java/nvim-java',
  ft = 'java',
  config = function()
    local on_attach = function(client, bufnr)
      local nmap = function(keys, func, desc)
        vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
      end

      nmap('<leader>lr', vim.lsp.buf.rename, 'Lsp Rename')
      nmap('<leader>la', vim.lsp.buf.code_action, 'Lsp code Action')

      nmap('gd', '<cmd>FzfLua lsp_definitions jump_to_single_result=true ignore_current_line=true<cr>', 'Goto [D]efinition')
      nmap('gr', '<cmd>FzfLua lsp_references jump_to_single_result=true ignore_current_line=true<cr>', 'Goto [R]eferences')
      nmap('gI', '<cmd>FzfLua lsp_implementations jump_to_single_result=true ignore_current_line=true<cr>', 'Goto [I]mplementation')
      nmap('gy', '<cmd>FzfLua lsp_typedefs jump_to_single_result=true ignore_current_line=true<cr>', 'Goto T[y]pe Definition')
      nmap('gD', vim.lsp.buf.declaration, 'Goto [D]eclaration')
      nmap(']d', vim.diagnostic.goto_next, 'Next diagnostic')
      nmap('[d', vim.diagnostic.goto_prev, 'Previous diagnostic')
      nmap('<leader>lq', vim.diagnostic.setloclist, 'Set diagnostic quickfix')
      nmap('<leader>ld', '<cmd>FzfLua diagnostics_document jump_to_single_result=true ignore_current_line=true<cr>', 'Open diagnostic list')
      nmap('<leader>ls', '<cmd>FzfLua lsp_document_symbols jump_to_single_result=true ignore_current_line=true<cr>', 'Lsp Document Symbols')
      nmap('<leader>lS', '<cmd>FzfLua lsp_live_workspace_symbols jump_to_single_result=true ignore_current_line=true<cr>', 'Lsp Workspace Symbols')
      nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
      nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
      nmap('<leader>lwa', vim.lsp.buf.add_workspace_folder, 'Lsp Workspace Add folder')
      nmap('<leader>lwr', vim.lsp.buf.remove_workspace_folder, 'Lsp Workspace Remove folder')
      nmap('<leader>lwl', function()
        vim.notify(
          vim.inspect(vim.lsp.buf.list_workspace_folders()),
          vim.log.levels.INFO,
          { title = 'LSP' }
        )
      end, 'Lsp Workspace List folders')
      nmap('<leader>lf', vim.lsp.buf.format, 'Lsp Format buffer')
    end

    -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    -- for ufo
    capabilities.textDocument.foldingRange = {
      dynamicRegistration = false,
      lineFoldingOnly = true,
    }
    capabilities = vim.tbl_deep_extend(
      'force',
      capabilities,
      require('cmp_nvim_lsp').default_capabilities()
    )
    require('java').setup()
    require('lspconfig').jdtls.setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })
  end
}
