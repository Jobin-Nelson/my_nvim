vim.api.nvim_buf_set_keymap(0, 'n', '<leader>cr', '<cmd>update <bar> !go run %<CR>', { desc = 'Go Run' })
vim.api.nvim_buf_set_keymap(0, 'n', '<leader>ct', '<cmd>update <bar> !go test %<CR>', { desc = 'Go Test' })
