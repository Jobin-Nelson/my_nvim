return {
  { "kylechui/nvim-surround", event = { "BufReadPost", "BufNewFile" },         opts = {} },
  { 'stevearc/dressing.nvim', event = 'VeryLazy',                              opts = {} },
  { 'sindrets/diffview.nvim', cmd = { 'DiffviewFileHistory', 'DiffViewOpen' }, opts = {} },
  { 'tpope/vim-fugitive',     cmd = 'Git' },
  { 'b0o/schemastore.nvim',   lazy = true },
}
