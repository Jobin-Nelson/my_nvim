return {
  { "kylechui/nvim-surround", event = { "BufReadPost", "BufNewFile" },         opts = {} },
  { 'tpope/vim-fugitive',     lazy = false },
  { 'b0o/schemastore.nvim',   lazy = true },
  { 'windwp/nvim-autopairs',  event = "InsertEnter",                           opts = {} },
  { 'stevearc/dressing.nvim', event = 'VeryLazy',                              opts = {} },
  -- { 'sindrets/diffview.nvim', cmd = { 'DiffviewFileHistory', 'DiffViewOpen' }, opts = {} },
  -- { 'tpope/vim-sleuth',       lazy = false },
}
