return {
  'stevearc/conform.nvim',
  keys = {
    {
      '<leader>cf',
      function()
        require('conform').format({ async = true })
      end,
      desc = 'Format Buffer'
    }
  },
  config = function()
    require('conform').setup({
      formatters_by_ft = {
        python = { 'ruff_format' },
        rust = { 'rustfmt' },
        go = { 'goimports', 'gofmt' },
        javascript = { 'prettierd', 'prettier', stop_after_first = true },
      },
      default_format_opts = {
        lsp_format = 'fallback',
      },
      formatters = {
        black = {
          prepend_args = { '--skip-string-normalization' },
        }
      }
    })
  end
}
