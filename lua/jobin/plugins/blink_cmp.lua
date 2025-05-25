return {
  'saghen/blink.cmp',
  event = 'InsertEnter',
  -- optional: provides snippets for the snippet source
  dependencies = { 'rafamadriz/friendly-snippets' },
  -- use a release tag to download pre-built binaries
  version = '1.*',

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    cmdline = {
      keymap = {
        -- recommended, as the default keymap will only show and select the next item
        ['<Tab>'] = { 'show', 'accept' },
      },
      completion = {
        menu = {
          ---@diagnostic disable-next-line: unused-local
          auto_show = function(ctx)
            return vim.fn.getcmdtype() == ':'
          end,
        }
      }
    },
    keymap = { preset = 'default' },
    appearance = {
      use_nvim_cmp_as_default = true,
      nerd_font_variant = 'mono',
      kind_icons = require('jobin.config.icons').kind,
    },
    completion = {
      menu = {
        border = 'rounded',
        winhighlight = '',
      },
      documentation = {
        -- disable if you run into performance issues
        auto_show = true,
        treesitter_highlighting = true,
        window = {
          border = 'rounded',
        }
      },
      list = {
        selection = {
          preselect = true,
          auto_insert = false,
        },
      }
    },
    -- snippets = {
    --   preset = 'luasnip',
    -- },
    -- default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, via `opts_extend`
    sources = {
      providers = {
        buffer = {
          max_items = 3,
          min_keyword_length = 3,
        },
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          -- make lazydev completions top priority (see `:h blink.cmp`)
          score_offset = 100,
        },
      },
      default = { 'lazydev', 'snippets', 'lsp', 'path', 'buffer' },
      per_filetype = {},
      -- optionally disable cmdline completions
      -- cmdline = {},
    },

    -- experimental signature help support
    signature = {
      enabled = true,
      window = {
        border = 'rounded',
      },
    },
  },
}
