return {
  'nvim-tree/nvim-tree.lua',
  event = 'VeryLazy',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    -- mappings
    vim.keymap.set('n', '<leader>e', '<cmd>lua require("nvim-tree.api").tree.toggle({find_file=true})<cr>', { desc = 'Open Explorer' })
    vim.keymap.set('n', '<leader>E', '<cmd>lua require("nvim-tree.api").tree.toggle()<cr>', { desc = 'Open Explorer (cwd)' })

    -- setup
    local function on_attach(bufnr)
      local api = require('nvim-tree.api')

      local function opts(desc)
        return { desc='nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
      end

      api.config.mappings.default_on_attach(bufnr)

      vim.keymap.set('n', 'l', api.node.open.edit, opts('Open'))
      vim.keymap.set('n', 'h', api.node.navigate.parent_close, opts('Close Directory'))
    end
    require('nvim-tree').setup({
      on_attach = on_attach,
      update_focused_file = {
        enable = true,
        update_root = true,
      }
    })
  end,
}
