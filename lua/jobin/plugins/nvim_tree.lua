return {
  'nvim-tree/nvim-tree.lua',
  event = 'VeryLazy',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    local function on_attach(bufnr)
      local api = require('nvim-tree.api')
    end
    require('nvim-tree').setup{}
  end,
}
