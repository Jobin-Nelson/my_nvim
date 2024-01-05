return {
	'akinsho/toggleterm.nvim',
  keys = {
    '<A-h>',
    '<A-v>',
  },
	config = function()
    vim.keymap.set('n', '<A-h>', '<cmd>ToggleTerm size=20 direction=horizontal<cr>', { desc = 'ToggleTerm Horizontal' })
    vim.keymap.set('n', '<A-v>', '<cmd>ToggleTerm size=80 direction=vertical<cr>', { desc = 'ToggleTerm Vertical' })
    vim.keymap.set('t', '<A-h>', '<esc><cmd>ToggleTerm direction=horizontal<cr>', { desc = 'ToggleTerm Horizontal' })
    vim.keymap.set('t', '<A-v>', '<esc><cmd>ToggleTerm direction=vertical<cr>', { desc = 'ToggleTerm Vertical' })
    vim.keymap.set('t', '<C-w>', '<C-\\><C-n><C-w>', { desc = 'Terminal window command' })
    require('toggleterm').setup()
  end,
}
