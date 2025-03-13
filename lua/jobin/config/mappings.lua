local map = vim.keymap.set

-- Leader
map({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Basic
-- map('n', '<leader>e', '<cmd>Lexplore 30<cr>', { desc = 'Open Explorer (cwd)' })
-- map('n', '<leader>E', '<cmd>silent! Lexplore %:h<cr>', { desc = 'Open Explorer (file)' })
-- map('n', '-', '<cmd>Ex<cr>', { desc = 'Open Explorer' })
map({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map('v', '<', '<gv', { silent = true, desc = 'Indent Inward' })
map('v', '>', '>gv', { silent = true, desc = 'Indent Outward' })
map('v', 'P', '"_dP', { silent = true, desc = 'Paste without yanking' })
map('n', '<C-Up>', '<cmd>resize -2<CR>', { desc = 'Resize split up' })
map('n', '<C-Down>', '<cmd>resize +2<CR>', { desc = 'Resize split down' })
map('n', '<C-Left>', '<cmd>vertical resize -2<CR>', { desc = 'Resize split left' })
map('n', '<C-Right>', '<cmd>vertical resize +2<CR>', { desc = 'Resize split right' })
map('n', '[q', '<cmd>cprevious<cr>', { desc = 'Previous Quickfix' })
map('n', ']q', '<cmd>cnext<cr>', { desc = 'Next Quickfix' })
map('n', '[b', '<cmd>bprevious<cr>', { desc = 'Next Buffer' })
map('n', ']b', '<cmd>bnext<cr>', { desc = 'Previous Buffer' })
map('n', '<C-w>m', '<cmd>wincmd | | wincmd _<cr>', { desc = 'Zoom Window' })

-- Buffer
map('n', '<leader>bo', '<cmd>update <bar> %bdelete <bar> edit# <bar> bdelete #<CR>', { desc = 'Delete Other buffers' })
map('n', '<leader>bk', '<cmd>call delete(expand("%:p")) <bar> bdelete!<cr>', { desc = 'Buffer Kill' })
map('n', '<leader>bh', '<cmd>lua require("jobin.config.custom.utils").delete_hidden_buffers()<cr>',
  { desc = 'Delete Hidden buffers' })
-- use snacks bufdelete
-- map('n', '<leader>bd', '<cmd>lua require("jobin.config.custom.utils").better_bufdelete()<cr>', { desc = 'Bufdelete' })

-- Packages
map('n', '<leader>ps', '<cmd>Lazy<cr>', { desc = 'Plugin Status' })
map('n', '<leader>pm', '<cmd>Mason<cr>', { desc = 'Mason Installer' })

-- Terminal
map('t', '<C-w>', '<C-\\><C-n><C-w>', { desc = 'Terminal window command' })
map('t', '<esc><esc>', '<C-\\><C-n>', { desc = 'Terminal normal mode' })
map({ 'n', 't' }, '<C-/>', function() require("jobin.config.custom.terminal").toggle_term() end,
  { desc = 'Toggle foating terminal' })
map({ 'n', 't' }, '<C-_>', function() require("jobin.config.custom.terminal").toggle_term() end,
  { desc = 'which_key_ignore' })
map('n', "<A-s>", function() require("jobin.config.custom.terminal").send_lines_term('normal') end,
  { desc = "Send lines to terminal" })
map('v', "<A-s>", function() require("jobin.config.custom.terminal").send_lines_term('visual') end,
  { desc = "Send lines to terminal" })

-- UI
map('n', '<leader>ur', '<cmd>nohlsearch <bar> diffupdate <bar> normal! <C-L><CR>', { desc = 'UI Refresh' })
map('n', '<leader>ui', '<cmd>lua require("jobin.config.custom.ui").set_indent()<cr>', { desc = 'Set Indent' })
map('n', '<leader>us', '<cmd>lua require("jobin.config.custom.ui").toggle_spell()<cr>', { desc = 'Toggle Spell' })
map('n', '<leader>ud', '<cmd>lua require("jobin.config.custom.ui").toggle_diagnostics()<cr>',
  { desc = 'Toggle Diagnostics' })
map('n', '<leader>ut', '<cmd>lua require("jobin.config.custom.ui").toggle_transparency()<cr>',
  { desc = 'Toggle Transparency' })
map('n', '<leader>uh', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({})) end,
  { desc = 'Toggle Inlay Hints' })

-- Custom
map('n', '<leader>js', ':%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>', { desc = 'Substitute word' })
map('n', '<leader>jy', '<cmd>let @+=@% | echo "Filepath copied to clipboard"<cr>', { desc = 'Copy Filepath' })
map('n', '<leader>jx', '<cmd>.lua<cr>', { desc = 'Execute lua' })
map('v', '<leader>jx', ':lua<cr>', { desc = 'Execute lua' })
map('n', '<leader>ja', ':<Up><cr>', { desc = 'Run Last Command' })
map('n', '<leader>jS', ':normal! [s1z=``<cr>', { desc = 'Fix last Spelling error' })
map('n', '<leader>jp', '<cmd>set relativenumber! number! showmode! showcmd! hidden! ruler!<cr>',
  { desc = 'Presentation Mode' })
map('n', '<leader>jb', '<cmd>lua require("jobin.config.custom.utils").box(60)<cr>', { desc = 'Box header' })
map('n', '<leader>jB', '<cmd>lua require("jobin.config.custom.utils").box()<cr>', { desc = 'Box word' })
map('n', '<leader>jc', '<cmd>lua require("jobin.config.custom.git").cd_git_root()<cr>', { desc = 'Cd Git Root' })
map('n', '<leader>jr', '<cmd>lua require("jobin.config.custom.utils").rename_file()<cr>', { desc = 'Rename File' })
map('n', '<leader>jl', '<cmd>lua require("jobin.config.custom.utils").leet()<cr>', { desc = 'Leetcode Daily' })
map('v', '<leader>jt', ':lua require("jobin.config.custom.utils").titleCase()<cr>', { desc = 'TitleCase' })
map({ 'n', 'v' }, '<leader>gB', function() require('jobin.config.custom.git').open() end, { desc = 'Git Browse' })
-- map('n', '<leader>jj', '<cmd>lua require("jobin.config.custom.utils").start_journal()<cr>', { desc = 'Start Journal' })
-- map('n', '<leader>jt', '<cmd>lua require("jobin.config.custom.org_tangle").tangle()<cr>', { desc = 'Org Tangle' })

-- Work
map('n', '<leader>we', '<cmd>lua require("jobin.config.custom.work_stuff.email_update").open()<cr>',
  { desc = 'Send Email' })
map('n', '<leader>wt', '<cmd>lua require("jobin.config.custom.work_stuff.jira.issue").get()<cr>',
  { desc = 'Source Ticket' })
map('n', '<leader>ws', '<cmd>lua require("jobin.config.custom.work_stuff.jira.subtask").get()<cr>',
  { desc = 'Source SubTask' })
map('n', '<leader>wo', '<cmd>lua require("jobin.config.custom.work_stuff.jira.issue").open()<cr>',
  { desc = 'Open Ticket' })
map('n', '<leader>wf', '<cmd>lua require("jobin.config.custom.work_stuff.jira.search").list_filter_issues()<cr>',
  { desc = 'Source Filter Issues' })
