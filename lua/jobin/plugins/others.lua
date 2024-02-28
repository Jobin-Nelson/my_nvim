return {
  { "dhruvasagar/vim-table-mode", keys = { "<leader>tm" } },
  { "dhruvasagar/vim-zoom",       keys = { "<C-w>m" } },
  { "numToStr/Comment.nvim",      event = { "BufReadPost", "BufNewFile" }, config = true },
  { "windwp/nvim-autopairs",      event = "InsertEnter",                   config = true },
  { "kylechui/nvim-surround",     event = { "BufReadPost", "BufNewFile" }, config = true },
  { 'b0o/schemastore.nvim' },
  { 'stevearc/dressing.nvim',     event = 'VeryLazy',                      config = true },
  { 'akinsho/toggleterm.nvim',    cmd = 'ToggleTerm',                      config = true },
}
