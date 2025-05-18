return {
  {
    'kristijanhusak/vim-dadbod-ui',
    lazy = true,
    dependencies = {
      { 'tpope/vim-dadbod', cmd = 'DB' },
    },
    cmd = {
      'DBUI',
      'DBUIToggle',
      'DBUIAddConnection',
      'DBUIFindBuffer',
    },
    init = function()
      -- Your DBUI configuration
      vim.g.db_ui_use_nerd_fonts = 1
    end,
  },

  {
    'kristijanhusak/vim-dadbod-completion',
    ft = { 'sql', 'mysql', 'plsql' },
    lazy = true
  },

  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = { ensure_installed = { "sql" } },
  },

  {
    "saghen/blink.cmp",
    optional = true,
    opts = function(_, opts)
      opts.sources.providers.dadbod = {
        name = 'Dadbod',
        module = 'vim_dadbod_completion.blink',
      }
      opts.sources.per_filetype.sql = { 'snippets', 'dadbod', 'buffer' }
    end,
    dependencies = {
      "kristijanhusak/vim-dadbod-completion",
    },
  }
}
