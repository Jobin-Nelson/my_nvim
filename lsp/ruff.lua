return {
  cmd_env = { RUFF_TRACE = 'messages' },
  init_options = {
    settings = {
      logLevel = "error",
    },
  },
  on_attach = function(client, bufnr)
    vim.keymap.set('n', '<leader>lo', function()
      vim.lsp.buf.code_action({
        apply = true,
        context = {
          only = { 'source.organizeImports' },
          diagnostics = {},
        },
      })
    end, { buffer = bufnr, desc = 'Organize Imports' })

    -- Disable hover in favor of Pyright
    client.server_capabilities.hoverProvider = false
  end
}
