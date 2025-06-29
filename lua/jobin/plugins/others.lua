return {
  { "kylechui/nvim-surround", event = { "BufReadPost", "BufNewFile" },         opts = {} },
  { 'sindrets/diffview.nvim', cmd = { 'DiffviewFileHistory', 'DiffViewOpen' }, opts = {} },
  { 'tpope/vim-fugitive',     cmd = 'Git' },
  { 'b0o/schemastore.nvim',   lazy = true },
  { 'windwp/nvim-autopairs',  event = "InsertEnter",                           opts = {} },
  { 'stevearc/dressing.nvim', event = 'VeryLazy',                              opts = {} },
  { 'tpope/vim-sleuth',       lazy = false },
  { 'mbbill/undotree',        lazy = false,                                    keys = { { '<leader>uu', '<cmd>UndotreeToggle<cr>' } } },
}
