local map = vim.keymap.set

-- General
map('n', '<leader>f<cr>', function() Snacks.picker.resume() end, { desc = 'Find Resume' })
map('n', '<leader>fB', function() Snacks.picker() end, { desc = 'Find Builtins' })
map('n', '<leader>fr', function() Snacks.picker.recent() end, { desc = 'Find Recent files' })
map('n', '<leader>fb', function() Snacks.picker.buffers() end, { desc = 'Find Buffers' })
map('n', '<leader>ff',
  function() Snacks.picker.files({ cwd = require("jobin.config.custom.git").get_git_root_buf() }) end,
  { desc = 'Find Files' })
map('n', '<leader>fF', function() Snacks.picker.files() end, { desc = 'Find Files (cwd)' })
map('n', '<leader>fg',
  function() Snacks.picker.git_files({ cwd = require("jobin.config.custom.git").get_git_root_buf() }) end,
  { desc = 'Find Git Files' })
map('n', '<leader>fG', function() Snacks.picker.git_files() end, { desc = 'Find Git Files (cwd)' })
map('n', '<leader>fh', function() Snacks.picker.help() end, { desc = 'Find Help' })
map('n', '<leader>fc', function() Snacks.picker.grep_word() end, { desc = 'Find word under Cursor' })
map('n', '<leader>fw',
  function() Snacks.picker.grep({ cwd = require("jobin.config.custom.git").get_git_root_buf() }) end,
  { desc = 'Find words (root)' })
map('n', '<leader>fW', function() Snacks.picker.grep() end, { desc = 'Find words (cwd)' })
map('n', '<leader>fC', function() Snacks.picker.commands() end, { desc = 'Find Commands' })
map('n', '<leader>fk', function() Snacks.picker.keymaps() end, { desc = 'Find Keymaps' })
map('n', "<leader>f'", function() Snacks.picker.marks() end, { desc = 'Find Marks' })
map('n', "<leader>fm", function() Snacks.picker.man() end, { desc = 'Find Man Pages' })
map('n', '<leader>ft', function() Snacks.picker.colorschemes() end, { desc = 'Find Themes' })
map('n', '<leader>fD', function() Snacks.picker.diagnostics() end, { desc = 'Find Diagnostics workspace' })
map('n', '<leader>f/', function() Snacks.picker.lines() end, { desc = 'Buffer Search' })

-- git
map('n', '<leader>gb', function() Snacks.picker.git_branches() end, { desc = 'Git Branches' })
map('n', '<leader>gt', function() Snacks.picker.git_status() end, { desc = 'Git Status' })
map('n', '<leader>gc', function() Snacks.picker.git_log() end, { desc = 'Git Commits' })
map('n', '<leader>gC', function() Snacks.picker.git_log_file() end, { desc = 'Git Buffer Commits' })
map('v', '<leader>gC', function() Snacks.picker.git_log_line() end, { desc = 'Git Buffer Commits line' })

-- custom
map('n', '<leader>fA', function() Snacks.picker.files({ cwd = '~/playground/projects/config-setup' }) end,
  { desc = 'Find Config Setup' })
map('n', '<leader>fa', function() Snacks.picker.files({ cwd = vim.fn.stdpath('config') }) end, { desc = 'Find Config' })
map('n', '<leader>fd', function() require('jobin.config.custom.snacks.picker').dot_files() end,
  { desc = 'Find Dotfiles' })
map('n', '<leader>fz', function() Snacks.picker.zoxide() end, { desc = 'Find Zoxide' })
map('n', '<leader>fp', function() Snacks.picker.projects() end, { desc = 'Find Projects' })
map('n', '<leader>fL',  function() Snacks.picker.files({cwd=vim.fs.joinpath(vim.fn.stdpath("data"), "lazy")}) end,
  { desc = 'Find profiles' })
map('n', '<leader>fM',  function() require('jobin.config.custom.snacks.picker').move_file() end, { desc = 'Move File' })
map('n', '<leader>fI', function() Snacks.picker.icons() end, { desc = 'Pick Icon' })

-- Second brain
map('n', '<leader>fss',  function() require('jobin.config.custom.snacks.picker').second_brain() end,
  { desc = 'Find Second brain files' })
map('n', '<leader>fsi', function() require('jobin.config.custom.snacks.picker').second_brain_template() end,
  { desc = 'Insert Second brain Templates' })

-- Explorer
map('n', '<leader>e', function() Snacks.picker.explorer() end, { desc = 'Explorer' })
