return {
  "NeogitOrg/neogit",
  event = 'VeryLazy',
  dependencies = {
    "nvim-lua/plenary.nvim",
    "sindrets/diffview.nvim",
    "nvim-telescope/telescope.nvim",
  },
  config = function()
    vim.keymap.set('n', '<leader>gg', '<cmd>Neogit<cr>', {desc = 'Open Neogit'})

    require('neogit').setup()
  end,
}
