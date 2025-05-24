local map = vim.keymap.set
map('n', '[g', '<cmd>Gitsigns prev_hunk<cr>', { desc = 'Goto Previous Hunk' })
map('n', ']g', '<cmd>Gitsigns next_hunk<cr>', { desc = 'Goto Next Hunk' })
map('n', '<leader>gp', '<cmd>Gitsigns preview_hunk<cr>', { desc = 'Preview Hunk' })
map('n', '<leader>gr', '<cmd>Gitsigns reset_buffer<cr>', { desc = 'Git Reset Buffer' })
map({ 'n', 'v' }, '<leader>gh', ':Gitsigns reset_hunk<cr>', { desc = 'Git Reset Hunk' })
map('n', '<leader>gl', '<cmd>Gitsigns blame_line<cr>', { desc = 'Git blame Line' })
map({ 'n', 'v' }, '<leader>gs', ':Gitsigns stage_hunk<cr>', { desc = 'Git Stage Hunk' })
map('n', '<leader>gS', '<cmd>Gitsigns stage_buffer<cr>', { desc = 'Git Stage Buffer' })
map({ 'n', 'v' }, '<leader>gu', ':Gitsigns undo_stage_hunk<cr>', { desc = 'Unstage Git Hunk' })

return {
  'lewis6991/gitsigns.nvim',
  event = { "BufReadPre", "BufNewFile" },
  opt = {
    -- signs = {
    --   add = { text = '+' },
    --   change = { text = '~' },
    --   delete = { text = '_' },
    --   topdelete = { text = '‾' },
    --   changedelete = { text = '~' },
    -- },
    preview_config = {
      border = 'rounded'
    },
    worktrees = vim.g.git_worktrees,
  }
}
