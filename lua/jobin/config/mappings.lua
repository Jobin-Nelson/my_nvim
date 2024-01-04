local map = vim.keymap.set

-- Leader
map({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Basic
-- map('n', '<leader>e', '<cmd>Lexplore 30<cr>', { desc = 'Open Explorer (cwd)' })
-- map('n', '<leader>E', '<cmd>silent! Lexplore %:h<cr>', { desc = 'Open Explorer (file)' })
-- map('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
-- map('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map('n', 'k', "gk", { silent = true })
map('n', 'j', "gj", { silent = true })
map('v', '<', '<gv', { silent = true, desc = 'Indent Inward' })
map('v', '>', '>gv', { silent = true, desc = 'Indent Outward' })
map('v', 'P', '"_dP', { silent = true, desc = 'Paste without yanking' })
map('n', '<C-Up>', '<cmd>resize -2<CR>', { desc = 'Resize split up' })
map('n', '<C-Down>',  '<cmd>resize +2<CR>', { desc = 'Resize split down' })
map('n', '<C-Left>',  '<cmd>vertical resize -2<CR>', { desc = 'Resize split left' })
map('n', '<C-Right>',  '<cmd>vertical resize +2<CR>', { desc = 'Resize split right' })

-- Buffer
map('n', '[b', '<cmd>bprevious<cr>', { desc = 'Next Buffer' })
map('n', ']b', '<cmd>bnext<cr>', { desc = 'Previous Buffer' })
map('n', '<leader>bo', '<cmd>update <bar> %bdelete <bar> edit# <bar> bdelete #<CR>', { desc = 'Delete Other buffers' })
map('n', '<leader>bh', '<cmd>lua require("jobin.config.custom.utils").delete_hidden_buffers()<cr>', { desc = 'Delete Hidden buffers' })
map('n', '<leader>bk', '<cmd>call delete(expand("%:p")) <bar> bdelete!<cr>', { desc = 'Buffer Kill' })
-- map('n', '<leader>bd', '<cmd>BufferLinePickClose<cr>', { desc = 'Buffer Delete' })
-- map('n', '<leader>br', '<cmd>BufferLineCloseRight<cr>', { desc = 'Buffer close Right' })
-- map('n', '<leader>bl', '<cmd>BufferLineCloseLeft<cr>', { desc = 'Buffer close Left' })
map('n', '<leader>b/', '<cmd>lua require("telescope.builtin").current_buffer_fuzzy_find()<cr>', { desc = 'Buffer Search' })

-- Git

-- Telescope

-- Packages
map('n', '<leader>ps', '<cmd>Lazy<cr>', { desc = 'Plugin Status' })
map('n', '<leader>pm', '<cmd>Mason<cr>', { desc = 'Mason Installer' })

-- Terminal
-- map('n', '<A-h>', '<cmd>ToggleTerm size=20 direction=horizontal<cr>', { desc = 'ToggleTerm Horizontal' })
-- map('n', '<A-v>', '<cmd>ToggleTerm size=80 direction=vertical<cr>', { desc = 'ToggleTerm Vertical' })
-- map('t', '<A-h>', '<C-\\><C-n><cmd>ToggleTerm direction=horizontal<cr>', { desc = 'ToggleTerm Horizontal' })
-- map('t', '<A-v>', '<C-\\><C-n><cmd>ToggleTerm direction=vertical<cr>', { desc = 'ToggleTerm Vertical' })
map('t', '<C-w>', '<C-\\><C-n><C-w>', { desc = 'Terminal window command' })

-- UI
map('n', '<leader>ui', '<cmd>lua require("jobin.config.custom.ui").set_indent()<cr>', { desc = 'Set Indent' })
map('n', '<leader>us', '<cmd>lua require("jobin.config.custom.ui").toggle_spell()<cr>', { desc = 'Toggle Spell' })
map('n', '<leader>ur', '<cmd>nohlsearch <bar> diffupdate <bar> normal! <C-L><CR>', { desc = 'UI Refresh' })

-- Other
map('n', '[q', '<cmd>cprevious<cr>', { desc = 'Previous Quickfix' })
map('n', ']q', '<cmd>cnext<cr>', { desc = 'Next Quickfix' })
map('n', '<leader>we', '<cmd>lua require("jobin.config.custom.work_stuff.email_update").open()<cr>', { desc = 'Send Email' })
map('n', '<leader>wt', '<cmd>lua require("jobin.config.custom.work_stuff.get_ticket").populate_ticket()<cr>', { desc = 'Source Ticket' })
map('n', '<leader>jb', '<cmd>lua require("jobin.config.custom.utils").scratch_buffer()<cr>', { desc = 'Scratch buffer' })
map('n', '<leader>js', ':%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>', { desc = 'Substitute word' })
map('n', '<leader>jj', '<cmd>lua require("jobin.config.custom.utils").start_journal()<cr>', { desc = 'Start Journal' })
map('n', '<leader>jt', '<cmd>lua require("jobin.config.custom.org_tangle").tangle()<cr>', { desc = 'Org Tangle' })
map('n', '<leader>jc', '<cmd>lua require("jobin.config.custom.utils").cd_git_root()<cr>', { desc = 'Cd Git Root' })
map('n', '<leader>jr', '<cmd>lua require("jobin.config.custom.utils").rename_file()<cr>', { desc = 'Rename File' })
map('n', '<leader>jm', '<cmd>lua require("jobin.config.custom.my_pickers").move_file()<cr>', { desc = 'Move File' })
map('n', '<leader>jl', '<cmd>lua require("jobin.config.custom.utils").leet()<cr>', { desc = 'Leetcode Daily' })
map({'n', 't'}, '<leader>th', '<cmd>lua require("jobin.config.custom.utils").term_toggle()<cr>', { desc = 'Toggle Horizontal Term' })
