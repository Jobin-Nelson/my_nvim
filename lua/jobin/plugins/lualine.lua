return {
  "nvim-lualine/lualine.nvim",
  event = 'VeryLazy',
  config = function()
    local icons = require "jobin.config.icons"

    local diff = {
      "diff",
      colored = true,
      symbols = { added = icons.git.LineAdded, modified = icons.git.LineModified, removed = icons.git.LineRemoved }, -- Changes the symbols used by the diff.
    }

    require("lualine").setup {
      options = {
        theme = 'catppuccin',
        -- component_separators = { left = "", right = "" },
        -- section_separators = { left = "", right = "" },
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        ignore_focus = { "NvimTree" },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", icons.git.Branch },
        lualine_c = { diff, },
        lualine_x = { "diagnostics" },
        lualine_y = { "filetype", 'location' },
        lualine_z = { "progress" },
      },
      extensions = { "quickfix", "man", "fugitive" },
    }
  end,
}

