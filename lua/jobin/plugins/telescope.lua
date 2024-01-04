return {
  {
    'nvim-telescope/telescope.nvim',
    event = 'VeryLazy',
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
      -- mappings
      local map = vim.keymap.set
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
      -- custom
      map('n', '<leader>fa', '<cmd>lua require("jobin.config.custom.my_pickers").find_config()<cr>', { desc = 'Find Config' })
      map('n', '<leader>fd', '<cmd>lua require("jobin.config.custom.my_pickers").find_dotfiles()<cr>', { desc = 'Find Dotfiles' })
      map('n', '<leader>fz', '<cmd>lua require("jobin.config.custom.my_pickers").find_zoxide()<cr>', { desc = 'Find Zoxide' })
      map('n', '<leader>fss', '<cmd>lua require("jobin.config.custom.my_pickers").find_second_brain_files()<cr>', { desc = 'Find Second brain files' })
      map('n', '<leader>fsi', '<cmd>lua require("jobin.config.custom.my_pickers").insert_second_brain_template()<cr>', { desc = 'Insert Second brain Templates' })
      map('n', '<leader>fO', '<cmd>lua require("jobin.config.custom.my_pickers").find_org_files()<cr>', { desc = 'Find Org files' })
      map('n', '<leader>fp', '<cmd>lua require("jobin.config.custom.my_pickers").find_projects()<cr>', { desc = 'Find Projects' })
      map('n', '<leader>fj', '<cmd>lua require("jobin.config.custom.my_pickers").find_journal()<cr>', { desc = 'Find Journal' })
      -- git
      map('n', '<leader>gb', '<cmd>lua require("telescope.builtin").git_branches()<cr>', { desc = 'Git Branches' })
      map('n', '<leader>gt', '<cmd>lua require("telescope.builtin").git_status()<cr>', { desc = 'Git Status' })
      map('n', '<leader>gc', '<cmd>lua require("telescope.builtin").git_commits()<cr>', { desc = 'Git Commits' })
      map('v', '<leader>gc', '<cmd>lua require("telescope.builtin").git_bcommits_range()<cr>', { desc = 'Git Range Commits' })

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
              ["<A-y>"] = my_actions.copy_entry,
            },
          },
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
