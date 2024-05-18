return {
  'Exafunction/codeium.vim',
  event = 'BufEnter',
  config = function()
    vim.g.codeium_enabled = false
    vim.g.codeium_disable_bindings = 1

    vim.keymap.set('i', '<A-l>', function() return vim.fn['codeium#Accept']() end, { expr = true, silent = true, desc = 'Codeium Accept' })
    vim.keymap.set('i', '<A-]>', function() return vim.fn['codeium#CycleCompletions'](1) end, { desc = 'Codeium Cycle Next' })
    vim.keymap.set('i', '<A-[>', function() return vim.fn['codeium#CycleCompletions'](-1) end, { desc = 'Codeium Cycle Prev' })
    vim.keymap.set('i', '<A-x>', function() return vim.fn['codeium#Clear']() end, { desc = 'Codeium Clear' })
    vim.keymap.set('i', '<A-c>', function() return vim.fn['codeium#Complete']() end, { desc = 'Codeium Complete' })
    vim.keymap.set({ 'n', 'i' }, '<A-t>', function()
      vim.cmd('CodeiumToggle')
      local codeium_status = vim.g.codeium_enabled and 'Enabled' or 'Disabled'
      print('Codeium is ' .. codeium_status)
    end, { desc = 'Codeium Toggle' })
  end
}
