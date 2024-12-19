return {
  'saghen/blink.cmp',
  event = 'InsertEnter',
  -- optional: provides snippets for the snippet source
  dependencies = { 'rafamadriz/friendly-snippets' },
  -- use a release tag to download pre-built binaries
  version = 'v0.*',

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  ---@diagnostic disable: missing-fields
  opts = {
    keymap = { preset = 'default' },
    appearance = {
      use_nvim_cmp_as_default = true,
      nerd_font_variant = 'mono',
      kind_icons = require('jobin.config.icons').kind,
    },
    enabled = function()
      -- TODO: remove when blink supports cmdline completion
      return not vim.tbl_contains({ 'vim' }, vim.bo.filetype) and vim.bo.buftype ~= "prompt"
    end,
    completion = {
      menu = {
        border = 'single',
        winhighlight = '',
      },
      documentation = {
        -- disable if you run into performance issues
        treesitter_highlighting = true,
        window = {
          border = 'single',
        }
      },
      { accept = { auto_brackets = { enabled = true } } },
    },

    -- default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, via `opts_extend`
    sources = {
      providers = {
        dadbod = {
          name = 'Dadbod',
          module = 'vim_dadbod_completion.blink',
        },
        orgmode = {
          name = 'Orgmode',
          module = 'orgmode.org.autocompletion.blink',
        },
      },
      default = { 'lsp', 'path', 'snippets', 'buffer' },
      per_filetype = {
        sql = { 'snippets', 'dadbod', 'buffer', },
        org = { 'snippets', 'orgmode', 'buffer', },
      },
      -- optionally disable cmdline completions
      -- cmdline = {},
    },

    -- experimental signature help support
    signature = {
      enabled = true,
      window = {
        border = 'single',
      },
    },

  },
  -- allows extending the providers array elsewhere in your config
  -- without having to redefine it
  opts_extend = { "sources.default" },
}
