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
      '<leader><S-m>', function() require('harpoon'):list():add() end, desc = 'Harpoon Mark'
    },
  },
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  config = function()
    local harpoon = require("harpoon")

    harpoon:setup({})

    for i = 1, 9 do
      vim.keymap.set("n", "<leader>" .. i, function() harpoon:list():select(i) end, { desc = 'Harpoon Select ' .. i })
    end

    -- Toggle previous & next buffers stored within Harpoon list
    -- vim.keymap.set("n", "<S-h>", function() harpoon:list():prev() end, { desc = 'Harpoon Previous' })
    -- vim.keymap.set("n", "<S-l>", function() harpoon:list():next() end, { desc = 'Harpoon Next' })
  end,
}
