vim.keymap.set('n', '<leader>gg', '<cmd>Neogit<cr>', { desc = 'Open Neogit' })
vim.keymap.set('n', '<leader>gC', '<cmd>Neogit commit<cr>', { desc = 'Git Commit' })

return {
  "NeogitOrg/neogit",
  cmd = 'Neogit',
  dependencies = {
    "nvim-lua/plenary.nvim",
    "sindrets/diffview.nvim",
    "nvim-telescope/telescope.nvim",
  },
  opts = {},
}
