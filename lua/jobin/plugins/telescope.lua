local map = vim.keymap.set
map('n', '<leader>f<cr>', '<cmd>Telescope resume<cr>', { desc = 'Find Oldfiles' })
map('n', '<leader>fB', '<cmd>Telescope builtin<cr>', { desc = 'Find Builtins' })
map('n', '<leader>fo', '<cmd>Telescope oldfiles<cr>', { desc = 'Find Oldfiles' })
map('n', '<leader>fb', '<cmd>Telescope buffers<cr>', { desc = 'Find Buffers' })
map('n', '<leader>ff', '<cmd>Telescope find_files<cr>', { desc = 'Find Files' })
map('n', '<leader>fF', '<cmd>Telescope find_files hidden=True no_ignore=True<cr>', { desc = 'Find Files' })
map('n', '<leader>fg', '<cmd>Telescope git_files use_file_path=True use_git_root=True recurse_submodules=True<cr>', { desc = 'Find Git Files (root)' })
map('n', '<leader>fG', '<cmd>Telescope git_files use_file_path=False use_git_root=False recurse_submodules=True<cr>', { desc = 'Find Git Files (cwd)' })
map('n', '<leader>fh', '<cmd>Telescope help_tags<cr>', { desc = 'Find Help' })
map('n', '<leader>fc', '<cmd>Telescope grep_string<cr>', { desc = 'Find word under Cursor' })
map('n', '<leader>fW', '<cmd>Telescope live_grep<cr>', { desc = 'Find words (cwd)' })
map('n', '<leader>fC', '<cmd>Telescope commands<cr>', { desc = 'Find Commands' })
map('n', '<leader>fk', '<cmd>Telescope keymaps<cr>', { desc = 'Find Keymaps' })
map('n', "<leader>f'", '<cmd>Telescope marks<cr>', { desc = 'Find Marks' })
map('n', "<leader>fm", '<cmd>Telescope man_pages<cr>', { desc = 'Find Man Pages' })
map('n', '<leader>ft', '<cmd>Telescope colorscheme<cr>', { desc = 'Find Themes' })
map('n', '<leader>fD', '<cmd>Telescope diagnostics<cr>', { desc = 'Find Diagnostics' })
map('n', '<leader>f/', '<cmd>Telescope current_buffer_fuzzy_find<cr>', { desc = 'Buffer Search' })
-- git
map('n', '<leader>gb', '<cmd>Telescope git_branches<cr>', { desc = 'Git Branches' })
map('n', '<leader>gt', '<cmd>Telescope git_status<cr>', { desc = 'Git Status' })
map('n', '<leader>gc', '<cmd>Telescope git_commits<cr>', { desc = 'Git Commits' })
map('v', '<leader>gc', '<cmd>Telescope git_bcommits_range<cr>', { desc = 'Git Range Commits' })
-- Custom
map('n', '<leader>fA', '<cmd>Telescope find_files search_dirs=~/playground/projects/config-setup<cr>', {desc = 'Find Config Setup' })

return {
  {
    'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    keys = {
      { '<leader>fw',  '<cmd>lua require("telescope.builtin").live_grep({cwd=require("jobin.config.custom.utils").get_git_root_buf()})<cr>', desc = 'Find words (root)' },
      -- custom
      { '<leader>fa',  '<cmd>lua require("jobin.config.custom.my_pickers").find_config()<cr>',                                               desc = 'Find Config' },
      { '<leader>fd',  '<cmd>lua require("jobin.config.custom.my_pickers").find_dotfiles()<cr>',                                             desc = 'Find Dotfiles' },
      { '<leader>fz',  '<cmd>lua require("jobin.config.custom.my_pickers").find_zoxide()<cr>',                                               desc = 'Find Zoxide' },
      { '<leader>fss', '<cmd>lua require("jobin.config.custom.my_pickers").find_second_brain_files()<cr>',                                   desc = 'Find Second brain files' },
      { '<leader>fsi', '<cmd>lua require("jobin.config.custom.my_pickers").insert_second_brain_template()<cr>',                              desc = 'Insert Second brain Templates' },
      { '<leader>fO',  '<cmd>lua require("jobin.config.custom.my_pickers").find_org_files()<cr>',                                            desc = 'Find Org files' },
      { '<leader>fp',  '<cmd>lua require("jobin.config.custom.my_pickers").find_projects()<cr>',                                             desc = 'Find Projects' },
      { '<leader>fj',  '<cmd>lua require("jobin.config.custom.my_pickers").find_journal()<cr>',                                              desc = 'Find Journal' },
      { '<leader>fi',  '<cmd>lua require("jobin.config.custom.my_pickers").find_docker_images()<cr>',                                        desc = 'Find Docker Images' },
    },
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
    },
    config = function()
      -- setup
      local actions = require('telescope.actions')
      local my_actions = require('jobin.config.custom.my_actions')
      require('telescope').setup({
        pickers = {
          buffers = {
            mappings = {
              n = {
                ['d'] = 'delete_buffer',
              },
            }
          }
        },
        defaults = {
          mappings = {
            i = {
              ["<C-s>"] = actions.cycle_previewers_next,
              ["<C-a>"] = actions.cycle_previewers_prev,
              ["<C-Enter>"] = actions.to_fuzzy_refine,
              ["<A-y>"] = my_actions.copy_entry,
            },
          },
          file_ignore_patterns = {
            'node_modules',
            -- '.git',
            'venv',
            '__pycache__',
          },
          hidden = true,
          git_worktrees = vim.g.git_worktrees,
          prompt_prefix = "❯ ",
          selection_caret = "❯ ",
          path_display = { "truncate" },
          sorting_strategy = "ascending",
          layout_config = {
            horizontal = {
              prompt_position = "top",
              preview_width = 0.55,
            },
            vertical = {
              mirror = false,
            },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
          },
        }
      })
      require('telescope').load_extension('fzf')
    end
  },
}
