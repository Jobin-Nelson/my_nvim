return {
  "goolord/alpha-nvim",
  event = "VimEnter",
  config = function()
    if vim.o.filetype == 'lazy' then
      vim.cmd.close()
      vim.api.nvim_create_autocmd({ "User" }, {
        once = true,
        pattern = { "AlphaReady" },
        callback = function()
          require('lazy').show()
        end,
      })
    end

    local dashboard = require "alpha.themes.dashboard"
    local icons = require "jobin.config.icons"

    local function button(sc, txt, keybind, keybind_opts)
      local b = dashboard.button(sc, txt, keybind, keybind_opts)
      b.opts.hl_shortcut = "Macro"
      return b
    end

    dashboard.section.header.val = {
      [[ ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗]],
      [[ ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║]],
      [[ ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║]],
      [[ ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║]],
      [[ ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║]],
      [[ ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
      [[                  JOBIN NELSON                     ]],

    }

    dashboard.section.buttons.val = {
      button("f", icons.ui.Lens .. " Find file", "<cmd>FzfLua files<CR>"),
      button("n", icons.ui.NewFile .. " New file", "<cmd>ene <BAR> startinsert<CR>"),
      button("s", icons.ui.History .. " Load session", "<cmd> lua require('persistence').load()<CR>"),
      button("p", icons.git.Repo .. " Find project", "<cmd>lua require('jobin.config.custom.my_pickers').find_projects()<CR>"),
      button("o", icons.ui.Files .. " Recent files", "<cmd>FzfLua oldfiles<CR>"),
      button("w", icons.ui.Text .. " Find text", "<cmd>FzfLua live_grep<CR>"),
      button("a", icons.ui.Gear .. " Config", '<cmd>FzfLua files cwd=~/.config/nvim<cr>'),
      button("q", icons.ui.SignOut .. " Quit", "<cmd>qa<CR>"),
    }

    dashboard.section.footer.val = "[[ Jobin Nelson ]]"

    dashboard.section.header.opts.hl = "String"
    dashboard.section.buttons.opts.hl = "Macro"
    dashboard.section.footer.opts.hl = "Type"

    dashboard.opts.opts.noautocmd = true
    require("alpha").setup(dashboard.opts)

    vim.api.nvim_create_autocmd("User", {
      once = true,
      pattern = "LazyVimStarted",
      callback = function()
        local stats = require("lazy").stats()
        local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
        dashboard.section.footer.val = "Loaded " .. stats.count .. " plugins  in " .. ms .. "ms"
        pcall(vim.cmd.AlphaRedraw)
      end,
    })
  end,
}
