return {
  'lewis6991/gitsigns.nvim',
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local map = vim.keymap.set
    map('n', '[g', '<cmd>lua require("gitsigns").prev_hunk()<cr>', { desc = 'Goto Previous Hunk' })
    map('n', ']g', '<cmd>lua require("gitsigns").next_hunk()<cr>', { desc = 'Goto Next Hunk' })
    map('n', '<leader>gp', '<cmd>lua require("gitsigns").preview_hunk()<cr>', { desc = 'Preview Hunk' })
    map('n', '<leader>gr', '<cmd>lua require("gitsigns").reset_buffer()<cr>', { desc = 'Git Reset Buffer' })
    map('n', '<leader>gh', '<cmd>lua require("gitsigns").reset_hunk()<cr>', { desc = 'Git Reset Hunk' })
    map('n', '<leader>gl', '<cmd>lua require("gitsigns").blame_line()<cr>', { desc = 'Git blame Line' })
    map('n', '<leader>gs', '<cmd>lua require("gitsigns").stage_hunk()<cr>', { desc = 'Git Stage Hunk' })
    map('n', '<leader>gS', '<cmd>lua require("gitsigns").stage_buffer()<cr>', { desc = 'Git Stage Buffer' })
    map('n', '<leader>gu', '<cmd>lua require("gitsigns").undo_stage_hunk()<cr>', { desc = 'Unstage Git Hunk' })
    map('n', '<leader>gd', '<cmd>lua require("gitsigns").diffthis()<cr>', { desc = 'View Git Diff' })

    require('gitsigns').setup({
      -- signs = {
      --   add = { text = '+' },
      --   change = { text = '~' },
      --   delete = { text = '_' },
      --   topdelete = { text = '‾' },
      --   changedelete = { text = '~' },
      -- },
      worktrees = vim.g.git_worktrees,
    })
  end,
}
