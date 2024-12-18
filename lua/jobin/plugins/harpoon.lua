return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  keys = {
    {
      '<leader>h',
      function()
        local harpoon = require('harpoon')
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end,
      desc = 'Harpoon Menu'
    },
    {
      '<S-m>', function() require('harpoon'):list():add() end, desc = 'Harpoon Mark'
    },
    {
      "<leader>1", function() require('harpoon'):list():select(1) end, desc = 'Harpoon Select 1'
    }
  },
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  config = function()
    local harpoon = require("harpoon")

    harpoon:setup({})

    -- vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end, { desc = 'Harpoon Select 1' })
    vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end, { desc = 'Harpoon Select 2' })
    vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end, { desc = 'Harpoon Select 3' })
    vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end, { desc = 'Harpoon Select 4' })

    -- Toggle previous & next buffers stored within Harpoon list
    -- vim.keymap.set("n", "<S-h>", function() harpoon:list():prev() end, { desc = 'Harpoon Previous' })
    -- vim.keymap.set("n", "<S-l>", function() harpoon:list():next() end, { desc = 'Harpoon Next' })
  end,
}
