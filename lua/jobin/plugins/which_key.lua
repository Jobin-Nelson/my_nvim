return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  config = function()
    local mappings = {
      f = { name = "Find" },
      b = { name = "Buffers" },
      l = { name = "Lsp" },
      p = { name = "Package" },
      t = { name = "Terminal" },
      w = { name = "Work" },
      j = { name = "Custom" },
      g = { name = "Git" },
      d = { name = "Debug" },
      u = { name = "UI" },
      o = { name = "Org mode" },
    }
    local opts = {
      mode = "n",
      prefix = "<leader>",
      buffer = nil,
      silent = true,
      noremap = true,
      nowait = true,
    }
    local which_key = require('which-key')
    which_key.setup()
    which_key.register(mappings, opts)
  end
}
