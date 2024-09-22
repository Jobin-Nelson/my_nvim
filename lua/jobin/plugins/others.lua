return {
  { "dhruvasagar/vim-table-mode", keys = { "<leader>tm" } },
  { "dhruvasagar/vim-zoom",       keys = { "<C-w>m" } },
  { "windwp/nvim-autopairs",      event = "InsertEnter",                           config = true },
  { "kylechui/nvim-surround",     event = { "BufReadPost", "BufNewFile" },         config = true },
  { 'stevearc/dressing.nvim',     event = 'VeryLazy',                              config = true },
  { 'akinsho/toggleterm.nvim',    cmd = 'ToggleTerm',                              config = true },
  { 'sindrets/diffview.nvim',     cmd = { 'DiffviewFileHistory', 'DiffViewOpen' }, config = true },
}
