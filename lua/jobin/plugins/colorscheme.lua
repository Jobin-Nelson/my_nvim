local integrations = {
  nvimtree = true,
  ts_rainbow = false,
  -- dap = { enabled = true, enable_ui = true },
  symbols_outline = true,
  aerial = true,
  alpha = true,
  cmp = true,
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
}

return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy     = false,
    priority = 1000,
    config = function()
      require('catppuccin').setup({
        transparent_background = true,
        dim_inactive = {
          enabled = false,
          shade = 'dark',
          percentage = 0.15,
        },
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
      })

      vim.cmd('colorscheme terafox')
    end,
  },
}
