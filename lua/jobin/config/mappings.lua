local map = vim.keymap.set

-- Leader
map({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Basic
map('n', '<leader>e', '<cmd>Lexplore 30<cr>', { desc = 'Open Explorer (cwd)' })
map('n', '<leader>E', '<cmd>silent! Lexplore %:h<cr>', { desc = 'Open Explorer (file)' })
-- map('n', '<leader>e', '<cmd>lua require("nvim-tree.api").tree.toggle({find_file=true})<cr>', { desc = 'Open Explorer' })
map('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
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
map('n', '[g', '<cmd>lua require("gitsigns").prev_hunk()<cr>', { desc = 'Goto Previous Hunk' })
map('n', ']g', '<cmd>lua require("gitsigns").next_hunk()<cr>', { desc = 'Goto Next Hunk' })
map('n', '<leader>gp', '<cmd>lua require("gitsigns").preview_hunk()<cr>', { desc = 'Preview Hunk' })
map('n', '<leader>gr', '<cmd>lua require("gitsigns").reset_buffer()<cr>', { desc = 'Git Reset Buffer' })
map('n', '<leader>gh', '<cmd>lua require("gitsigns").reset_hunk()<cr>', { desc = 'Git Reset Hunk' })
map('n', '<leader>gl', '<cmd>lua require("gitsigns").blame_line()<cr>', { desc = 'Git blame Line' })
map('n', '<leader>gs', '<cmd>lua require("gitsigns").stage_hunk()<cr>', { desc = 'Git Stage Hunk' })
map('n', '<leader>gS', '<cmd>lua require("gitsigns").stage_buffer()<cr>', { desc = 'Git Stage Buffer' })
map('n', '<leader>gu', '<cmd>lua require("gitsigns").undo_stage_hunk()<cr>', { desc = 'Unstage Git Hunk' })
map('n', '<leader>gd', '<cmd>lua require("gitsigns").diffthis()<cr>', { desc = 'View Git Diff' })
map('n', '<leader>gb', '<cmd>lua require("telescope.builtin").git_branches()<cr>', { desc = 'Git Branches' })
map('n', '<leader>gt', '<cmd>lua require("telescope.builtin").git_status()<cr>', { desc = 'Git Status' })
map('n', '<leader>gc', '<cmd>lua require("telescope.builtin").git_commits()<cr>', { desc = 'Git Commits' })
map('v', '<leader>gc', '<cmd>lua require("telescope.builtin").git_bcommits_range()<cr>', { desc = 'Git Range Commits' })

-- Telescope
map('n', '<leader>f<cr>', '<cmd>lua require("telescope.builtin").resume()<cr>', { desc = 'Find Oldfiles' })
map('n', '<leader>fB', '<cmd>lua require("telescope.builtin").builtin()<cr>', { desc = 'Find Builtins' })
map('n', '<leader>fo', '<cmd>lua require("telescope.builtin").oldfiles()<cr>', { desc = 'Find Oldfiles' })
map('n', '<leader>fb', '<cmd>lua require("telescope.builtin").buffers()<cr>', { desc = 'Find Buffers' })
map('n', '<leader>ff', '<cmd>lua require("telescope.builtin").find_files()<cr>', { desc = 'Find Files' })
map('n', '<leader>fF', '<cmd>lua require("telescope.builtin").find_files({no_ignore=true,hidden=true})<cr>', { desc = 'Find Files' })
map('n', '<leader>fh', '<cmd>lua require("telescope.builtin").help_tags()<cr>', { desc = 'Find Help' })
map('n', '<leader>fc', '<cmd>lua require("telescope.builtin").grep_string()<cr>', { desc = 'Find word under Cursor' })
map('n', '<leader>fw', '<cmd>lua require("telescope.builtin").live_grep()<cr>', { desc = 'Find words' })
map('n', '<leader>fC', '<cmd>lua require("telescope.builtin").commands()<cr>', { desc = 'Find Commands' })
map('n', '<leader>fk', '<cmd>lua require("telescope.builtin").keymaps()<cr>', { desc = 'Find Keymaps' })
map('n', "<leader>f'", '<cmd>lua require("telescope.builtin").marks()<cr>', { desc = 'Find Marks' })
map('n', "<leader>fm", '<cmd>lua require("telescope.builtin").man_pages()<cr>', { desc = 'Find Man Pages' })
map('n', '<leader>ft', '<cmd>lua require("telescope.builtin").colorscheme()<cr>', { desc = 'Find Themes' })
map('n', '<leader>fD', '<cmd>lua require("telescope.builtin").diagnostics()<cr>', { desc = 'Find Diagnostics' })
map('n', '<leader>fe', '<cmd>Telescope emoji<cr>', { desc = 'Find Emoji' })
map('n', '<leader>fa', '<cmd>lua require("jobin.config.custom.my_pickers").find_config()<cr>', { desc = 'Find Config' })
map('n', '<leader>fd', '<cmd>lua require("jobin.config.custom.my_pickers").find_dotfiles()<cr>', { desc = 'Find Dotfiles' })
map('n', '<leader>fz', '<cmd>lua require("jobin.config.custom.my_pickers").find_zoxide()<cr>', { desc = 'Find Zoxide' })
map('n', '<leader>fss', '<cmd>lua require("jobin.config.custom.my_pickers").find_second_brain_files()<cr>', { desc = 'Find Second brain files' })
map('n', '<leader>fsi', '<cmd>lua require("jobin.config.custom.my_pickers").insert_second_brain_template()<cr>', { desc = 'Insert Second brain Templates' })
map('n', '<leader>fO', '<cmd>lua require("jobin.config.custom.my_pickers").find_org_files()<cr>', { desc = 'Find Org files' })
map('n', '<leader>fp', '<cmd>lua require("jobin.config.custom.my_pickers").find_projects()<cr>', { desc = 'Find Projects' })
map('n', '<leader>fj', '<cmd>lua require("jobin.config.custom.my_pickers").find_journal()<cr>', { desc = 'Find Journal' })

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
