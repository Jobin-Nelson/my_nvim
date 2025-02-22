local map = vim.keymap.set
-- General
map('n', '<leader>f<cr>', '<cmd>FzfLua resume<cr>', { desc = 'Find Resume' })
map('n', '<leader>fB', '<cmd>FzfLua builtin<cr>', { desc = 'Find Builtins' })
map('n', '<leader>fr', '<cmd>FzfLua oldfiles<cr>', { desc = 'Find Recent files' })
map('n', '<leader>fb', '<cmd>FzfLua buffers<cr>', { desc = 'Find Buffers' })
map('n', '<leader>ff', function()
  require("fzf-lua").files({ cwd = require("jobin.config.custom.git").get_git_root_buf() })
end, { desc = 'Find Files' })
map('n', '<leader>fF', '<cmd>FzfLua files<cr>', { desc = 'Find Files (cwd)' })
map('n', '<leader>fg', function()
  require("fzf-lua").git_files({ cwd = require("jobin.config.custom.git").get_git_root_buf() })
end, { desc = 'Find Git Files' })
map('n', '<leader>fG', '<cmd>FzfLua git_files<cr>', { desc = 'Find Git Files (cwd)' })
map('n', '<leader>fh', '<cmd>FzfLua helptags<cr>', { desc = 'Find Help' })
map('n', '<leader>fH', '<cmd>FzfLua highlights<cr>', { desc = 'Find Highlight' })
map('n', '<leader>fc', '<cmd>FzfLua grep_cword<cr>', { desc = 'Find word under Cursor' })
map('n', '<leader>fw', function()
  require("fzf-lua").live_grep_glob({ cwd = require("jobin.config.custom.git").get_git_root_buf() })
end, { desc = 'Find words (root)' })
map('n', '<leader>fW', '<cmd>FzfLua live_grep_glob<cr>', { desc = 'Find words (cwd)' })
map('n', '<leader>fC', '<cmd>FzfLua commands<cr>', { desc = 'Find Commands' })
map('n', '<leader>fk', '<cmd>FzfLua keymaps<cr>', { desc = 'Find Keymaps' })
map('n', "<leader>f'", '<cmd>FzfLua marks<cr>', { desc = 'Find Marks' })
map('n', "<leader>fm", '<cmd>FzfLua manpages<cr>', { desc = 'Find Man Pages' })
map('n', '<leader>ft', '<cmd>FzfLua colorschemes<cr>', { desc = 'Find Themes' })
map('n', '<leader>f/', '<cmd>FzfLua blines<cr>', { desc = 'Buffer Search' })

-- git
map('n', '<leader>gb', '<cmd>FzfLua git_branches<cr>', { desc = 'Git Branches' })
map('n', '<leader>gt', '<cmd>FzfLua git_status<cr>', { desc = 'Git Status' })
map('n', '<leader>gc', '<cmd>FzfLua git_commits<cr>', { desc = 'Git Commits' })
map({ 'n', 'v' }, '<leader>gC', '<cmd>FzfLua git_bcommits<cr>', { desc = 'Git Buffer Commits' })

-- custom
map('n', '<leader>fA', '<cmd>FzfLua files cwd=~/playground/projects/config-setup<cr>',
  { desc = 'Find Config Setup' })
map('n', '<leader>fa', function()
  require("fzf-lua").files({ cwd = vim.fn.stdpath("config") })
end, { desc = 'Find Config' })
map('n', '<leader>fd', function()
  require("fzf-lua").files({
    cwd = "$HOME",
    cwd_prompt = false,
    prompt = "~/",
    cmd =
    "git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME ls-tree --name-only --full-tree -r HEAD"
  })
end, { desc = 'Find Dotfiles' })
map('n', '<leader>fz', function()
  require("jobin.config.custom.fzf.pickers").fzf_cd_dir("zoxide query -l")
end, { desc = 'Find Zoxide' })
map('n', '<leader>fp', function()
  require("jobin.config.custom.fzf.pickers").fzf_cd_dir("find ~/playground/projects -maxdepth 1 -mindepth 1 -type d")
end, { desc = 'Find Projects' })
map('n', '<leader>fP', '<cmd>FzfLua profiles<cr>', { desc = 'Find profiles' })
map('n', '<leader>fl', function()
  require("fzf-lua").files({ cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy") })
end, { desc = 'Find profiles' })
map('n', '<leader>fM', function()
  require("jobin.config.custom.fzf.pickers").fzf_move_file()
end, { desc = 'Move File' })
map('n', '<leader>fI', function()
  require("jobin.config.custom.fzf.pickers").fzf_icons()
end, { desc = 'Pick Icon' })

-- Second brain
map('n', '<leader>fss', function()
  require("jobin.config.custom.fzf.pickers").fzf_second_brain()
end, { desc = 'Find Second brain files' })
map('n', '<leader>fsi', function()
  require("jobin.config.custom.fzf.pickers").fzf_read_file({ cwd =
  "~/playground/projects/second_brain/Resources/Templates/" })
end, { desc = 'Insert Second brain Templates' })

-- Work
map('n', '<leader>fit',
  '<cmd>FzfLua files cwd=~/playground/dev/illumina/ticket_notes<cr>',
  { desc = 'Find Ticket notes' })
map('n', '<leader>fiu',
  '<cmd>FzfLua files cwd=~/playground/dev/illumina/utils<cr>',
  { desc = 'Find Utils' })

-- Orgmode
map('n', '<leader>fot', function()
  require("jobin.config.custom.fzf.pickers").fzf_org_live_grep("~/playground/projects/org_files")
end, { desc = 'Org Todo grep' })
map('n', '<leader>foT', function()
  require("jobin.config.custom.fzf.pickers").fzf_org_live_grep("~/playground/dev/illumina/ticket_notes/work_org_files")
end, { desc = 'Org Todo grep (Work)' })

return {
  "ibhagwan/fzf-lua",
  cmd = {
    'FzfLua', 'JQL', 'Todo',
  },
  -- optional for icon support
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    -- calling `setup` is optional for customization
    local actions = require "fzf-lua.actions"
    local my_actions = require "jobin.config.custom.fzf.actions"

    require("fzf-lua").setup({
      "default-title",
      winopts = {
        preview = {
          vertical = "down:45%",
          horizontal = "right:45%",
        },
      },
      defaults = {
        git_icons = false,
        file_icons = false,
        color_icons = false,
      },
      keymap = {
        fzf = {
          true, -- inherit from defaults
          ["ctrl-q"] = "select-all+accept",
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
        rg_glob = true,
        glob_flag = "--iglob",
        glob_separator = "%s%-%-",
        actions = {
          ["alt-h"] = actions.toggle_hidden,
          ["alt-i"] = actions.toggle_ignore,
        }
      },
      previewers = {
        builtin = {
          syntax_limit_b = 1024 * 100, -- 100KB
        }
      },
      hls = {
        backdrop = 'Normal',
        border = 'Normal',
        preview_border = 'Normal',
      }
    })

    -- use fzf-lua for vim.ui.select
    require("fzf-lua").register_ui_select()

    -- Custom User commands
    vim.api.nvim_create_user_command('JQL',
      function(opts)
        require('jobin.config.custom.fzf.pickers').fzf_search_jira(opts.args)
      end,
      { nargs = 1 }
    )


    vim.api.nvim_create_user_command('Todo', function(opts)
      local utils = require('jobin.config.custom.utils')
      local notify = function(res)
        vim.schedule(function()
          if res.code == 0 then
            vim.notify('Todo operation successful', vim.log.levels.INFO, { title = 'Todo' })
          else
            vim.notify('Todo operation failed', vim.log.levels.ERROR, { title = 'Todo' })
          end
        end)
      end

      -- range
      if opts.range == 2 then
        local lines = vim.api.nvim_buf_get_lines(0, opts.line1 - 1, opts.line2, false)
        for _, line in ipairs(lines) do
          vim.system(utils.shellsplit(line), {}, notify)
        end
        return
      end

      -- default
      if vim.startswith(opts.args, 'get') or opts.args == '' then
        return require('jobin.config.custom.fzf.pickers').fzf_todoist(
          opts.args == '' and 'todo.py get task' or 'todo.py ' .. opts.args
        )
      end

      -- print(vim.inspect(vim.list_extend({ 'todo.py' }, vim.shell(opts.args, ' '))))
      return vim.system(vim.list_extend({ 'todo.py' }, utils.shellsplit(opts.args)), {}, notify)
    end, {
      desc = 'Get/Add/Update/Delete/Close Todo',
      range = true,
      nargs = '*',
      complete = function(_, cmdline)
        local arg_list = vim.split(cmdline, '%s+')
        if #arg_list >= 2 then
          local flag = arg_list[#arg_list - 1]
          if vim.tbl_contains({ '-l', '--label' }, flag) then
            return vim.fn.systemlist({ 'todo.py', 'list', '--label' })
          elseif vim.tbl_contains({ '-p', '--priority' }, flag) then
            return vim.fn.systemlist({ 'todo.py', 'list', '--priority' })
          elseif '--project' == flag then
            return vim.fn.systemlist({ 'todo.py', 'list', '--project' })
          end
        end
        return {}
      end
    })
  end
}
