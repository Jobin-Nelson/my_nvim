return {
  "SmiteshP/nvim-navic",
  event = 'VeryLazy',
  dependencies = {
    'neovim/nvim-lspconfig',
  },
  config = function()
    local icons = require "jobin.config.icons"
    require("nvim-navic").setup {
      icons = icons.kind,
      lazy_update_context = true,
      highlight = true,
      lsp = {
        auto_attach = true,
      },
      separator = " " .. icons.ui.ChevronRight .. " ",
      depth_limit = 5,
      depth_limit_indicator = "..",
    }
  end,
}

