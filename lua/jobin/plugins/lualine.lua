return {
  "nvim-lualine/lualine.nvim",
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    local icons = require "jobin.config.icons"

    local modes = {
      ["N"] = icons.ui.Neovim,
      ["V"] = icons.ui.Visual,
      ["S"] = icons.ui.Visual,
      ["I"] = icons.ui.Insert,
      ["R"] = icons.ui.Replace,
      ["C"] = icons.ui.Fire,
      ["T"] = icons.ui.Terminal,
      ["P"] = icons.ui.HourGlass,
    }

    local branch = {
      "branch",
      icon = icons.git.Branch
    }

    local diff = {
      "diff",
      colored = true,
      symbols = {
        added = icons.git.LineAdded,
        modified = icons.git.LineModified,
        removed = icons.git.LineRemoved
      },
    }

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

    ---@return string
    local function lsp()
      local lsps = vim.tbl_map(function(client)
        return client.name
      end, vim.lsp.get_clients({ bufnr = 0 }))
      local res = {}
      if vim.list_contains(lsps, 'copilot') then table.insert(res, icons.kind.Copilot) end
      local lsps_string = vim.iter(lsps):filter(function(c) return c ~= 'copilot' end):join(', ')
      if lsps_string ~= '' then table.insert(res, icons.misc.Servers .. lsps_string) end
      return table.concat(res, ' │ ')
    end

    require("lualine").setup {
      options = {
        theme = 'auto',
        globalstatus = true,
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        -- component_separators = { left = "", right = "" },
        -- section_separators = { left = "", right = "" },
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
        lualine_a = { 'mode' },
        lualine_b = { branch },
        lualine_c = {
          diff,
          filler,
          filetype,
          filename,
        },
        lualine_x = {
          diagnostics,
          lsp,
        },
        lualine_y = { { "location", icon = icons.ui.Location } },
        lualine_z = { { "progress", icon = icons.ui.ProgressDown } },
      },
      extensions = { 'quickfix', 'man' },
      -- winbar = {
      --   lualine_x = { winbar_filename },
      -- },
      -- inactive_winbar = {
      --   lualine_x = { winbar_filename },
      -- }
    }
  end,
}
