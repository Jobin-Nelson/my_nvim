return {
  "nvim-lualine/lualine.nvim",
  event = { 'BufReadPre', 'BufNewFile' },
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

    local branch = {
      "branch",
      icon = icons.git.Branch
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

    local filler = '%= '

    local filetype = {
      'filetype',
      colored = true,
      icon_only = true,
      padding = { right = 0 }
    }

    local filename = {
      'filename',
      newfile_status = true,
      path = 1,
      shorting_target = 40,
      symbols = {
        modified = icons.ui.FileModified,
        readonly = icons.ui.FileReadOnly,
        unnamed = icons.ui.NewFile,
        newfile = icons.ui.NewFile,
      }
    }

    local winbar_filename = {
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
        theme = 'auto',
        globalstatus = true,
        -- component_separators = { left = "", right = "" },
        -- section_separators = { left = "", right = "" },
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        ignore_focus = { "NvimTree" },
        disabled_filetypes = {
          statusline = {
            'TelescopePrompt',
            'alpha',
            'lazy',
          }
        }
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { branch },
        lualine_c = { diff, filler, filetype, filename },
        lualine_x = { diagnostics },
        lualine_y = { 'location' },
        lualine_z = { "progress" },
      },
      extensions = { 'quickfix', 'man' },
      winbar = {
        lualine_x = { winbar_filename },
      },
      inactive_winbar = {
        lualine_x = { winbar_filename },
      }
    }
  end,
}
