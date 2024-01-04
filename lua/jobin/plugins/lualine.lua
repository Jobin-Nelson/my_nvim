return {
  "nvim-lualine/lualine.nvim",
  event = 'VeryLazy',
  config = function()
    local icons = require "jobin.config.icons"

    local diff = {
      "diff",
      colored = true,
      symbols = {
        added = icons.git.LineAdded,
        modified = icons.git.LineModified,
        removed = icons.git.LineRemoved
      },
    }

    local diagnostics = {
      'diagnostics',
      symbols = {
        error = icons.diagnostics.BoldError,
        warn = icons.diagnostics.BoldWarning,
        info = icons.diagnostics.BoldInformation,
        hint = icons.diagnostics.BoldHint,
      },
    }

    local filename = {
      'filename',
      newfile_status = true,
      path = 0,
      shorting_target = 40,
      symbols = {
        modified = icons.ui.FileModified,
        readonly = icons.ui.FileReadOnly,
        unnamed = icons.ui.NewFile,
        newfile = icons.ui.NewFile,
      }
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
        lualine_b = { { "branch", icon = icons.git.Branch } },
        lualine_c = { filename, diff },
        lualine_x = { diagnostics },
        lualine_y = { "filetype", 'location' },
        lualine_z = { "progress" },
      },
      extensions = { "quickfix", "man", "fugitive" },
    }
  end,
}
