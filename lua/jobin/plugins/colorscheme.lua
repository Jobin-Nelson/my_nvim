local integrations = {
  nvimtree = true,
  fzf = true,
  ts_rainbow = false,
  dap = { enabled = true, enable_ui = true },
  symbols_outline = true,
  aerial = true,
  alpha = true,
  dashboard = true,
  flash = true,
  gitsigns = true,
  headlines = true,
  illuminate = true,
  indent_blankline = { enabled = true },
  leap = true,
  lsp_trouble = true,
  mason = true,
  markdown = true,
  mini = true,
  native_lsp = {
    enabled = true,
    underlines = {
      errors = { "undercurl" },
      hints = { "undercurl" },
      warnings = { "undercurl" },
      information = { "undercurl" },
    },
  },
  navic = { enabled = true, custom_bg = "lualine" },
  neotest = true,
  neotree = true,
  noice = true,
  notify = true,
  semantic_tokens = true,
  telescope = true,
  treesitter = true,
  treesitter_context = true,
  which_key = true,
  blink_cmp = true,
}

return {
  {
    "catppuccin/nvim",
    name     = "catppuccin",
    lazy     = false,
    priority = 1000,
    config   = function()
      require('catppuccin').setup({
        transparent_background = true,
        dim_inactive = {
          enabled = false,
          shade = 'dark',
          percentage = 0.15,
        },
        custom_highlights = function(_)
          return {
            StatusLine = { link = 'Normal' },
            StatuslineMode = { bold = true },
            StatuslineProgress = { bold = true },
            TreesitterContextBottom = { underline = true },
          }
        end,
        integrations = integrations,
      })

      vim.cmd('colorscheme catppuccin')
    end
  },
  {
    'EdenEast/nightfox.nvim',
    -- lazy = false,
    -- priority = 1000,
    config = function()
      require('nightfox').setup({
        options = {
          transparent = false,
          dim_inactive = true,
          styles = {
            comments = 'italic',
          },
          modules = integrations,
        },
        groups = {
          all = {
            BlinkCmpDoc = { bg = "NONE" },
            BlinkCmpDocBorder = { bg = "NONE" },
          }
        }
      })

      vim.cmd('colorscheme terafox')
    end,
  },
  {
    "neanias/everforest-nvim",
    version = false,
    -- lazy = false,
    -- priority = 1000,
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require("everforest").setup({
        -- Your config here
        colours_override = function(palette)
          palette.bg_dim = "#151515"
          palette.bg0 = "#202025"
        end,
        on_highlights = function(hl, palette)
          hl.FloatBorder = { bg = palette.none }
          hl.NormalFloat = { bg = palette.none }
          hl.WinBar = { bg = palette.bg_dim }
          hl.WinBarNC = { bg = palette.bg_dim }
          hl.StatusLine = { link = 'Normal' }
          hl.StatuslineMode = { bold = true }
          hl.StatuslineProgress = { bold = true }
          hl.TreesitterContextBottom = { underline = true }
        end
      })
      vim.cmd('colorscheme everforest')
    end,
  }
}
