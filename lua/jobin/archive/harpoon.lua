for i = 1, 9 do
  vim.keymap.set("n", "<leader>" .. i, function() require('harpoon'):list():select(i) end, { desc = 'Harpoon Select ' .. i })
end

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
  opts = {},
}
