return {
  'saghen/blink.cmp',
  event = 'InsertEnter',
  -- optional: provides snippets for the snippet source
  dependencies = { 'L3MON4D3/LuaSnip' },
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
    completion = {
      menu = {
        border = 'single',
        winhighlight = '',
      },
      documentation = {
        -- disable if you run into performance issues
        auto_show = true,
        treesitter_highlighting = true,
        window = {
          border = 'single',
        }
      },
      list = {
        selection = {
          preselect = true,
          auto_insert = false,
        },
      }
    },
    snippets = {
      preset = 'luasnip',
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
        snippets = {
          score_offset = 1,
        },
        buffer = {
          max_items = 3,
          min_keyword_length = 3,
        },
        copilot = {
          name = 'copilot',
          module = 'blink-cmp-copilot',
          score_offset = 100,
          async = true,
          transform_items = function(_, items)
            local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
            local kind_idx = #CompletionItemKind + 1
            CompletionItemKind[kind_idx] = "Copilot"
            for _, item in ipairs(items) do
              item.kind = kind_idx
            end
            return items
          end,
        },
      },
      default = { 'snippets', 'lsp', 'path', 'copilot', 'buffer' },
      per_filetype = {
        sql = { 'snippets', 'dadbod', 'buffer', },
        org = { 'snippets', 'orgmode', 'path', 'buffer' },
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
}
