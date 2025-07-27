vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.hl.on_yank()
  end,
  group = vim.api.nvim_create_augroup('jobin/TextYankPost', { clear = true }),
  pattern = '*',
})

vim.api.nvim_create_autocmd({ 'FileType' }, {
  group = vim.api.nvim_create_augroup('jobin/bigfile', { clear = true }),
  desc = 'Disable features in big files',
  pattern = 'bigfile',
  callback = function(ev)
    vim.api.nvim_buf_call(ev.buf, function()
      vim.schedule(function()
        vim.bo[ev.buf].syntax = vim.filetype.match({ buf = ev.buf }) or ''
        vim.wo[0][0].foldmethod = 'indent'
      end)
    end)
  end
})

-- vim.api.nvim_create_autocmd('ColorScheme', {
--   group = vim.api.nvim_create_augroup('jobin/Colorscheme', { clear = true }),
--   callback = function(_)
--     vim.api.nvim_set_hl(0, 'TreesitterContextBottom', {
--       underline = true,
--     })
--   end,
-- })


