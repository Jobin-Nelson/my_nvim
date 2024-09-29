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

      nmap('gd', vim.lsp.buf.definition, 'Goto Definition')
      nmap('gr', require('telescope.builtin').lsp_references, 'Goto References')
      nmap('gI', vim.lsp.buf.implementation, 'Goto Implementation')
      nmap('gl', vim.diagnostic.open_float, 'Open diagnostic')
      nmap(']d', vim.diagnostic.goto_next, 'Next diagnostic')
      nmap('[d', vim.diagnostic.goto_prev, 'Previous diagnostic')
      nmap('<leader>lt', vim.lsp.buf.type_definition, 'Goto Type definition')
      nmap('<leader>lq', vim.diagnostic.setloclist, 'Set diagnostic quickfix')
      nmap('<leader>ld', require('telescope.builtin').diagnostics, 'Open diagnostic list')
      nmap('<leader>ls', require('telescope.builtin').lsp_document_symbols, 'Lsp Document Symbols')
      nmap('<leader>lS', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Lsp Workspace Symbols')
      nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
      nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
      nmap('gD', vim.lsp.buf.declaration, 'Goto Declaration')
      nmap('<leader>lwa', vim.lsp.buf.add_workspace_folder, 'Lsp Workspace Add folder')
      nmap('<leader>lwr', vim.lsp.buf.remove_workspace_folder, 'Lsp Workspace Remove folder')
      nmap('<leader>lwl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
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
