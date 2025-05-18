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
      python = { 'ruff_format', 'ruff_organize_imports' },
      rust = { 'rustfmt' },
      go = { 'goimports', 'gofmt' },
      javascript = { 'prettierd', 'prettier', stop_after_first = true },
      json = { 'jq' },
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
