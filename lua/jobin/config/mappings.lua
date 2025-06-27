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
map('n', '<C-w>m', '<cmd>wincmd | | wincmd _<cr>', { desc = 'Zoom Window' })
map('n', ']Z', 'zczjzo', { desc = 'Open Next Fold' })
map('n', '[Z', 'zczkzo', { desc = 'Open Prev Fold' })

-- Buffer
map('n', '<leader>bo', '<cmd>update <bar> %bdelete <bar> edit# <bar> bdelete #<CR>', { desc = 'Delete Other buffers' })
map('n', '<leader>bk', '<cmd>call delete(expand("%:p")) <bar> bdelete!<cr>', { desc = 'Buffer Kill' })
map('n', '<leader>bh', function() require('jobin.config.custom.utils').delete_hidden_buffers() end,
  { desc = 'Delete Hidden buffers' })
map('n', '<leader>bd', function() require('jobin.config.custom.utils').better_bufdelete() end,
  { desc = 'Better bufdelete' })

-- Packages
map('n', '<leader>z', '<cmd>Lazy<cr>', { desc = 'Plugin Status' })

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
map('n', '<leader>ui', function() require("jobin.config.custom.ui").set_indent() end, { desc = 'Set Indent' })
map('n', '<leader>us', function() require("jobin.config.custom.ui").toggle_spell() end, { desc = 'Toggle Spell' })
map('n', '<leader>ud', function() require("jobin.config.custom.ui").toggle_diagnostics() end,
  { desc = 'Toggle Diagnostics' })
map('n', '<leader>ut', function() require("jobin.config.custom.ui").toggle_transparency() end,
  { desc = 'Toggle Transparency' })
map('n', '<leader>uh', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({})) end,
  { desc = 'Toggle Inlay Hints' })

-- Custom
map('n', '<leader>js', ':%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>', { desc = 'Substitute word' })
map('n', '<leader>jy', '<cmd>let @+=@% | echo "Filepath copied to clipboard"<cr>', { desc = 'Copy Filepath' })
map('n', '<leader>jx', '<cmd>.lua<cr>', { desc = 'Execute lua' })
map('v', '<leader>jx', ':lua<cr>', { desc = 'Execute lua' })
map('n', '<leader>ja', ':<Up><cr>', { desc = 'Run Last Command' })
map('n', '<leader>jS', '[s1z=``', { desc = 'Fix last Spelling error' })
map('n', '<leader>jp', '<cmd>set relativenumber! number! showmode! showcmd! hidden! ruler!<cr>',
  { desc = 'Presentation Mode' })
map('n', '<leader>ji', '<cmd>!nsxiv <cfile><cr>', { desc = 'Image Preview' })
map('v', '<leader>jT', ":!tr -s ' ' | column -t -s '|' -o '|'<cr>", { desc = 'Format Table' })
map('n', '<leader>jb', function() require("jobin.config.custom.utils").box(60) end, { desc = 'Box header' })
map('n', '<leader>jB', function() require("jobin.config.custom.utils").box() end, { desc = 'Box word' })
map('n', '<leader>jc', function() require("jobin.config.custom.git").cd_git_root() end, { desc = 'Cd Git Root' })
map('n', '<leader>jr', function() require("jobin.config.custom.utils").rename_file() end, { desc = 'Rename File' })
map('n', '<leader>jl', function() require("jobin.config.custom.utils").leet() end, { desc = 'Leetcode Daily' })
map('v', '<leader>jt', function() require("jobin.config.custom.utils").titleCase() end, { desc = 'TitleCase' })
map({ 'n', 'v' }, '<leader>gB', function() require('jobin.config.custom.git').open() end, { desc = 'Git Browse' })
map({ 'n', 'v' }, '<leader>gy', function() require('jobin.config.custom.git').copy() end, { desc = 'Git Copy remote url' })
map('n', '<leader>Ls', function() require('jobin.config.custom.lsp').stop_lsp() end, { desc = 'Stop all LSP clients' })
map('n', '<leader>Lh', function() require('jobin.config.custom.lsp').stop_hidden_lsp() end,
  { desc = 'Stop hidden LSP clients' })
map('n', '<leader>Lp', function() require('jobin.config.custom.lsp').display_active_lsp() end, { desc = 'Display active LSP clients' })
-- map('n', '<leader>jj', function() require("jobin.config.custom.utils").start_journal() end, { desc = 'Start Journal' })
-- map('n', '<leader>jt', function() require("jobin.config.custom.org_tangle").tangle() end, { desc = 'Org Tangle' })

-- Text objects
-- for _, key in ipairs({ '=', '~' }) do
--   vim.keymap.set('v', 'i' .. key, string.format('t%soT%s', key, key), { desc = string.format('inner org %s', key) })
--   vim.keymap.set('v', 'a' .. key, string.format('f%soF%s', key, key), { desc = string.format('around org %s', key) })
--   vim.keymap.set('o', 'i' .. key, string.format('<cmd>normal! t%svT%s<CR>', key, key), { desc = string.format('inner org %s', key) })
--   vim.keymap.set('o', 'a' .. key, string.format('<cmd>normal! f%svF%s<CR>', key, key), { desc = string.format('around org %s', key) })
-- end

-- Work
map('n', '<leader>wd', function() require("jobin.config.custom.work_stuff.daily_update").open() end,
  { desc = "Open Daily Update" })
map('n', '<leader>wt', function() require("jobin.config.custom.work_stuff.jira.issue").get() end,
  { desc = 'Source Ticket' })
map('n', '<leader>ws', function() require("jobin.config.custom.work_stuff.jira.subtask").get() end,
  { desc = 'Source SubTask' })
map('n', '<leader>wo', function() require("jobin.config.custom.work_stuff.jira.issue").open(vim.api.nvim_get_current_line()) end,
  { desc = 'Open Ticket' })
map('n', '<leader>wf', function() require("jobin.config.custom.work_stuff.jira.search").list_filter_issues() end,
  { desc = 'Source Filter Issues' })
map('v', '<leader>jY', ':w !pandoc -t html -o - | xclip -sel c -t text/html<cr>', { desc = 'Copy to HTML' })
