vim.api.nvim_buf_set_keymap(0, 'n', '<leader>cr', '<cmd>update <bar> !gcc -Wall -Wextra -std=c11 % && ./a.out <CR>', { desc = 'GCC Run' })
