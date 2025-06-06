return {
  'stevearc/conform.nvim',
  keys = {
    {
      '<leader>lf',
      function()
        require('conform').format({ async = true })
      end,
      desc = 'Format Buffer'
    }
  },
  opts = {
    formatters_by_ft = {
      javascript = { 'prettier' },
      json = { 'jq' },
      sh = { 'shfmt' },
    },
    default_format_opts = {
      lsp_format = 'fallback',
    },
    formatters = {
      black = {
        prepend_args = { '--skip-string-normalization' },
      }
    }
  }
}
