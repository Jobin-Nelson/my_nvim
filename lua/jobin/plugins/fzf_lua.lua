local map = vim.keymap.set
map('n', '<leader>f<cr>', '<cmd>FzfLua resume<cr>', { desc = 'Find Oldfiles' })
map('n', '<leader>fB', '<cmd>FzfLua builtin<cr>', { desc = 'Find Builtins' })
map('n', '<leader>fo', '<cmd>FzfLua oldfiles<cr>', { desc = 'Find Oldfiles' })
map('n', '<leader>fb', '<cmd>FzfLua buffers<cr>', { desc = 'Find Buffers' })
map('n', '<leader>ff',
  '<cmd>lua require("fzf-lua").files({cwd=require("jobin.config.custom.utils").get_git_root_buf()})<cr>',
  { desc = 'Find Files' })
map('n', '<leader>fF', '<cmd>FzfLua files<cr>', { desc = 'Find Files (cwd)' })
map('n', '<leader>fg',
  '<cmd>lua require("fzf-lua").git_files({cwd=require("jobin.config.custom.utils").get_git_root_buf()})<cr>',
  { desc = 'Find Git Files' })
map('n', '<leader>fG', '<cmd>FzfLua git_files<cr>', { desc = 'Find Git Files (cwd)' })
map('n', '<leader>fh', '<cmd>FzfLua helptags<cr>', { desc = 'Find Help' })
map('n', '<leader>fc', '<cmd>FzfLua grep_cword<cr>', { desc = 'Find word under Cursor' })
map('n', '<leader>fw',
  '<cmd>lua require("fzf-lua").live_grep({cwd=require("jobin.config.custom.utils").get_git_root_buf()})<cr>',
  { desc = 'Find words (root)' })
map('n', '<leader>fW', '<cmd>FzfLua live_grep<cr>', { desc = 'Find words (cwd)' })
map('n', '<leader>fC', '<cmd>FzfLua commands<cr>', { desc = 'Find Commands' })
map('n', '<leader>fk', '<cmd>FzfLua keymaps<cr>', { desc = 'Find Keymaps' })
map('n', "<leader>f'", '<cmd>FzfLua marks<cr>', { desc = 'Find Marks' })
map('n', "<leader>fm", '<cmd>FzfLua manpages<cr>', { desc = 'Find Man Pages' })
map('n', '<leader>ft', '<cmd>FzfLua colorschemes<cr>', { desc = 'Find Themes' })
map('n', '<leader>fD', '<cmd>FzfLua diagnostics_workspace<cr>', { desc = 'Find Diagnostics worksapce' })
map('n', '<leader>f/', '<cmd>FzfLua blines<cr>', { desc = 'Buffer Search' })
-- git
map('n', '<leader>gb', '<cmd>FzfLua git_branches<cr>', { desc = 'Git Branches' })
map('n', '<leader>gt', '<cmd>FzfLua git_status<cr>', { desc = 'Git Status' })
map('n', '<leader>gc', '<cmd>FzfLua git_commits<cr>', { desc = 'Git Commits' })
map('v', '<leader>gC', '<cmd>FzfLua git_bcommits<cr>', { desc = 'Git Buffer Commits' })
-- custom
map('n', '<leader>fA', '<cmd>FzfLua files cwd=~/playground/projects/config-setup<cr>',
  { desc = 'Find Config Setup' })
map('n', '<leader>fa', '<cmd>FzfLua files cwd=~/.config/nvim<cr>',
  { desc = 'Find Config' })
map('n', '<leader>fd',
  '<cmd>lua require("fzf-lua").files({cwd="$HOME",cwd_prompt=false,prompt="~/",cmd="git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME ls-tree --name-only --full-tree -r HEAD"})<cr>',
  { desc = 'Find Dotfiles' })
map('n', '<leader>fz', '<cmd>lua require("jobin.config.custom.fzf_pickers").fzf_cd_dir("zoxide query -l")<cr>',
  { desc = 'Find Zoxide' })
map('n', '<leader>fss', '<cmd>FzfLua files cwd=~/playground/projects/second_brain<cr>',
  { desc = 'Find Second brain files' })
map('n', '<leader>fsi',
  '<cmd>lua require("jobin.config.custom.fzf_pickers").fzf_read_file("find ~/playground/projects/second_brain/Resources/Templates/")<cr>',
  { desc = 'Insert Second brain Templates' })
map('n', '<leader>fp',
  '<cmd>lua require("jobin.config.custom.fzf_pickers").fzf_cd_dir("find ~/playground/projects -maxdepth 1 -mindepth 1 -type d")<cr>',
  { desc = 'Find Projects' })
map('n', '<leader>fP', '<cmd>FzfLua profiles<cr>', { desc = 'Find profiles' })
-- map('n', '<leader>fj', '<cmd>lua require("jobin.config.custom.my_pickers").find_journal()<cr>',
--   { desc = 'Find Journal' })
-- map('n', '<leader>fi', '<cmd>lua require("jobin.config.custom.my_pickers").find_docker_images()<cr>',
--   { desc = 'Find Docker Images' })
-- map('n', '<leader>fe', '<cmd>lua require("jobin.config.custom.my_pickers").find_docker_containers()<cr>',
--   { desc = 'Find Docker Containers' })

return {
  "ibhagwan/fzf-lua",
  cmd = {
    'FzfLua'
  },
  -- optional for icon support
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    -- calling `setup` is optional for customization
    local actions = require "fzf-lua.actions"
    local my_actions = require "jobin.config.custom.fzf_actions"

    require("fzf-lua").setup({
      "default-title",
      keymap = {
        builtin = {
          true, -- inherit from defaults
          ["<c-u>"] = "preview-page-up",
          ["<c-d>"] = "preview-page-down",
        },
        fzf = {
          true, -- inherit from defaults
          ["ctrl-q"] = "select-all+accept",
          ["ctrl-u"] = "preview-page-up",
          ["ctrl-d"] = "preview-page-down",
          ["ctrl-x"] = "jump",
        },
      },
      files = {
        actions = {
          ["alt-h"] = actions.toggle_hidden,
          ["alt-i"] = actions.toggle_ignore,
          ["ctrl-y"] = my_actions.copy_entry,
        }
      },
      grep = {
        actions = {
          ["alt-h"] = actions.toggle_hidden,
          ["alt-i"] = actions.toggle_ignore,
        }
      }
    })
  end
}
