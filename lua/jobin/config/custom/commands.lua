-- ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
-- ┃                        FileTypes                         ┃
-- ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛


-- vim.filetype.add({
--   pattern = {
--     ['.*'] = {
--       function(path, buf)
--         local bigfile_size = 1.5 * 1024 * 1024 -- 1.5MB
--         return vim.bo[buf]
--             and vim.bo[buf].filetype ~= 'bigfile'
--             and path
--             and vim.fn.getfsize(path) > bigfile_size
--             and 'bigfile'
--             or nil
--       end
--     }
--   }
-- })


-- ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
-- ┃                        Commands                          ┃
-- ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛


vim.api.nvim_create_user_command('DiffOrig', function()
  local start = vim.api.nvim_get_current_buf()
  vim.cmd('vnew | set buftype=nofile | read ++edit # | 0d_ | diffthis')
  local scratch = vim.api.nvim_get_current_buf()

  vim.cmd('wincmd p | diffthis')

  -- Map `q` for both buffers to exit diff view and delete scratch buffer
  for _, buf in ipairs({ scratch, start }) do
    vim.keymap.set('n', 'q', function()
      vim.api.nvim_buf_delete(scratch, { force = true })
      vim.keymap.del('n', 'q', { buffer = start })
    end, { buffer = buf })
  end
end, {})


-- ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
-- ┃                      Auto Commands                       ┃
-- ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛


vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = vim.api.nvim_create_augroup('YankHighlight', { clear = true }),
  pattern = '*',
})

-- vim.api.nvim_create_autocmd({ 'FileType' }, {
--   group = vim.api.nvim_create_augroup('bigfile', { clear = true }),
--   pattern = 'bigfile',
--   callback = function(ev)
--     vim.api.nvim_buf_call(ev.buf, function()
--       vim.cmd('NoMatchParen')
--       vim.cmd('UfoDetach')
--       local local_opts = {
--         foldmethod = 'manual',
--         statuscolumn = '',
--         conceallevel = 0,
--       }
--       for k, v in pairs(local_opts) do
--         vim.api.nvim_set_option_value(k, v, { scope = 'local', win = ev.win })
--       end
--       vim.schedule(function()
--         vim.bo[ev.buf].syntax = vim.filetype.match({ buf = ev.buf }) or ''
--       end)
--     end)
--   end
-- })
