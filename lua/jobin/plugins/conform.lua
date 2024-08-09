return {
  'stevearc/conform.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  keys = { '<leader>cf' },
  config = function()
    vim.keymap.set('n', '<leader>cf', function()
      require('conform').format({ async = true })
    end, { desc = 'Format Buffer' })

    require('conform').setup({
      formatters_by_ft = {
        python = { 'isort', 'black', },
        rust = { 'rustfmt' },
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
