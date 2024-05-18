return {
  "NeogitOrg/neogit",
  event = 'VeryLazy',
  dependencies = {
    "nvim-lua/plenary.nvim",
    "sindrets/diffview.nvim",
    "nvim-telescope/telescope.nvim",
  },
  branch = 'nightly',
  config = function()
    vim.keymap.set('n', '<leader>gg', '<cmd>Neogit<cr>', {desc = 'Open Neogit'})
    vim.keymap.set('n', '<leader>gC', '<cmd>Neogit commit<cr>', {desc = 'Git Commit'})

    require('neogit').setup({})
  end,
}
