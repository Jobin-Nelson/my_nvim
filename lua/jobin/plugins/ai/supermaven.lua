return {
  'supermaven-inc/supermaven-nvim',
  event = 'InsertEnter',
  opts = {
    keymaps = {
      accept_suggestion = "<M-l>",
      clear_suggestion = "<M-e>",
      accept_word = "<M-w>",
    },
    ignore_filetypes = { "text", "markdown", "org" },
    -- color = {
    --   suggestion_color = "#ffffff",
    --   cterm = 244,
    -- },
    -- log_level = "info",              -- set to "off" to disable logging completely
    -- disable_inline_completion = false, -- disables inline completion for use with cmp
    -- disable_keymaps = false,         -- disables built in keymaps for more manual control
  }
}
