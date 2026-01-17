return {
  {
    "catppuccin/nvim",
    name     = "catppuccin",
    lazy     = false,
    priority = 1000,
    config   = function()
      require('catppuccin').setup({
        transparent_background = true,
        float = {
          transparent = true,
          solid = false
        },
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
      })

      vim.cmd('colorscheme catppuccin')
    end
  },
  {
    'EdenEast/nightfox.nvim',
    lazy = true,
    -- priority = 1000,
    config = function()
      require('nightfox').setup({
        options = {
          transparent = true,
          dim_inactive = false,
          styles = {
            comments = 'italic',
          },
          -- modules = integrations,
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
    lazy = true,
    -- priority = 1000,
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require("everforest").setup({
        inlay_hints_background = 'dimmed',
        transparent_background_level = 1,
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
