return {
  'stevearc/oil.nvim',
  lazy = false,
  keys = {
    {
      "-",
      "<cmd>Oil<cr>",
      desc = "Open parent directory",
    },
  },
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {
    default_file_explorer = true,
    delete_to_trash = true,
    skip_confirm_for_simple_edits = true,
    keymaps = {
      ['gy'] = 'actions.yank_entry',
      ['<C-v>'] = { 'actions.select', opts = { vertical = true }},
      ['<C-s>'] = { 'actions.select', opts = { horizontal = true }},
    },
    view_options = {
      natural_order = "fast",
      show_hidden = true,
    },
    win_options = {
      wrap = true,
    },
  },
  -- Optional dependencies
  -- dependencies = { { "echasnovski/mini.icons", opts = {} } },
  dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
}
