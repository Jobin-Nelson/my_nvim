local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local sorters = require('telescope.sorters')
local actions = require('telescope.actions')
local previewers = require('telescope.previewers')
local previewers_utils = require('telescope.previewers.utils')
local action_state = require('telescope.actions.state')
local conf = require('telescope.config').values
local dropdown_theme = require('telescope.themes').get_dropdown()

local second_brain = vim.fs.normalize('~/playground/second_brain')

---@return string[]
local function get_dotfiles()
  local econf_file = vim.fn.expand('~/.local/bin/econf.sh')

  local econf = io.open(econf_file, 'r')
  if econf == nil then
    error('No econf.sh file found')
  end

  -- Seek till Files=(
  for line in econf:lines() do
    if string.match(line, '^%s*FILES=%(') then break end
  end

  -- Read in dotfiles
  local dotfiles = {}
  for line in econf:lines() do
    if string.match(line, '^%s*$') then break end
    local file_path = string.match(line, '.* - (.*)"$')
    if file_path then
      table.insert(dotfiles, file_path)
    end
  end
  econf:close()

  if vim.tbl_isempty(dotfiles) then
    error('No dotfiles found in array FILES in econf.sh')
  end

  return dotfiles
end

---@return string[]
local function get_projects()
  local project_dir = vim.fs.normalize('~/playground/projects')
  local projects = {}

  if not vim.fn.isdirectory(project_dir) then
    error(string.format('Directory %s not found', project_dir))
  end
  for name, type in vim.fs.dir(project_dir) do
    if type == 'directory' then
      table.insert(projects, {
        name,
        table.concat({ project_dir, name }, '/'),
      })
    end
  end

  return projects
end

---@param entry string
---@return table<string, string>
local function zoxide_entry_maker(entry)
  local trimmed = string.gsub(entry, '^%s*(.-)%s*$', '%1')
  local path = string.gsub(trimmed, '^[^%s]* (.*)$', '%1')
  local z_score = tonumber(string.gsub(trimmed, '^([^%s]*) .*$', '%1'), 10)

  return {
    value = path,
    ordinal = path,
    display = path,
    z_score = z_score,
    path = path,
  }
end

local M = {}

M.find_projects = function()
  local opts = dropdown_theme
  pickers.new(opts, {
    prompt_title = 'Projects',
    finder = finders.new_table({
      results = get_projects(),
      entry_maker = function(entry)
        return {
          value = entry,
          display = entry[1],
          ordinal = entry[1],
        }
      end,
    }),
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr, _)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        if selection then
          vim.cmd('tcd ' .. selection.value[2])
          vim.notify(
            'Directory changed to ' .. selection.value[1],
            vim.log.levels.INFO,
            { title = 'Telescope' }
          )
        else
          vim.notify(
            'No directory selected',
            vim.log.levels.INFO,
            { title = 'Telescope' }
          )
        end
      end)
      return true
    end
  }):find()
end

M.find_zoxide = function()
  local opts = dropdown_theme

  if vim.fn.executable('zoxide') ~= 1 then
    error('No zoxide found in the system')
  end

  pickers.new(opts, {
    prompt_title = 'Zoxide',
    finder = finders.new_oneshot_job(vim.fn.split('zoxide query -ls'), {
      entry_maker = zoxide_entry_maker,
    }),
    sorter = sorters.get_generic_fuzzy_sorter(opts),
    attach_mappings = function(prompt_bufnr, _)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        vim.cmd('tcd ' .. selection.path)
        vim.notify(
          'Directory changed to ' .. selection.path,
          vim.log.levels.INFO,
          { title = 'Telescope' }
        )
      end)
      return true
    end
  }):find()
end

M.find_config = function()
  local config_dir = vim.fn.stdpath('config')
  require('telescope.builtin').find_files({
    search_dirs = {
      config_dir .. '/init.lua',
      config_dir .. '/lua',
      config_dir .. '/after',
      config_dir .. '/snippets',
    },
    prompt_title = 'Find Config',
  })
end

M.insert_second_brain_template = function()
  local template_dir = second_brain .. '/Resources/Templates'
  require('telescope.builtin').find_files({
    search_dirs = { template_dir },
    prompt_title = 'Insert Template',
    attach_mappings = function(prompt_bufnr, _)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        vim.cmd('0read ' .. selection.value)
        vim.notify(
          'Inserted ' .. vim.fs.basename(selection.value),
          vim.log.levels.INFO,
          { title = 'Telescope' }
        )
      end)
      return true
    end
  })
end

M.find_second_brain_files = function()
  require('telescope.builtin').find_files({
    search_dirs = { second_brain },
    prompt_title = 'Second Brain Files',
    attach_mappings = function(_, map)
      map({ 'i', 'n' }, '<S-CR>', function(prompt_bufnr)
        local selection = action_state.get_current_line()
        if selection == '' then
          vim.notify(
            'Input value is empty',
            vim.log.levels.INFO,
            { title = 'Telescope' }
          )
          return true
        end
        actions.close(prompt_bufnr)
        local md_suffix = '.md'
        if selection:sub(- #md_suffix) ~= md_suffix then
          selection = selection .. md_suffix
        end
        local new_file = vim.fn.join({ second_brain, selection }, '/')
        vim.cmd('edit ' .. new_file)
      end)
      return true
    end
  })
end

M.move_file = function()
  local opts = dropdown_theme
  local cwd = require('jobin.config.custom.git').get_git_root_buf() or vim.uv.cwd()
  local rename_file = require('jobin.config.custom.utils').rename_file

  local cmd = { 'find', cwd, '(', '-path', '*/.git', '-o', '-path', '*/.obsidian', ')', '-prune', '-o', '-type', 'd',
    '-print' }
  -- fd doesn't return cwd
  -- if vim.fn.executable('fd') == 0 then
  --   cmd = {'fd', '-td', '.', cwd}
  -- end
  opts.entry_maker = function(entry)
    return {
      value = entry,
      ordinal = entry,
      display = string.sub(entry, #cwd + 2),
      path = entry,
    }
  end
  pickers.new(opts, {
    prompt_title = 'Move File',
    finder = finders.new_oneshot_job(cmd, opts),
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr, _)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        rename_file(selection.value)
      end)
      return true
    end
  }):find()
end

M.find_dotfiles = function()
  require('telescope.builtin').find_files({
    search_dirs = get_dotfiles(),
    prompt_title = 'Find Dotfiles',
  })
end

M.find_journal = function()
  local journal_dir = vim.fs.joinpath(second_brain, 'Resources', 'journal')
  require('telescope.builtin').live_grep({
    prompt_title = 'Find Journal',
    search_dirs = { journal_dir }
  })
end

M.find_docker_images = function(opts)
  pickers.new(opts, {
    prompt_title = 'Docker Images',
    finder = finders.new_async_job({
      command_generator = function()
        return { 'docker', 'images', '--format', 'json' }
      end,
      entry_maker = function(entry)
        local parsed = vim.json.decode(entry)
        if parsed then
          local image_name = parsed.Repository .. ':' .. parsed.Tag
          return {
            value = parsed,
            display = image_name,
            ordinal = image_name,
          }
        end
      end
    }),
    sorter = conf.generic_sorter(opts),
    previewer = previewers.new_buffer_previewer({
      title = "Docker Image Details",
      define_preview = function(self, entry)
        vim.api.nvim_buf_set_lines(self.state.bufnr, 0, 0, true, vim.iter({
          '# ' .. entry.value.ID,
          '```lua',
          vim.split(vim.inspect(entry.value), '\n'),
          '```',
        }):flatten():totable())
        previewers_utils.highlighter(self.state.bufnr, "markdown")
      end,
    }),
    attach_mappings = function(prompt_bufnr, _)
      local docker_run = function(window_orientation)
        return function()
          local selection = action_state.get_selected_entry()
          actions.close(prompt_bufnr)
          vim.cmd(window_orientation .. ' term://docker run --rm -it ' .. selection.value.Repository)
        end
      end
      actions.select_default:replace(docker_run('edit'))
      actions.select_horizontal:replace(docker_run('new'))
      actions.select_vertical:replace(docker_run('vnew'))
      actions.select_tab:replace(docker_run('tabedit'))
      return true
    end
  }):find()
end

M.find_docker_containers = function(opts)
  pickers.new(opts, {
    prompt_title = 'Docker Containers',
    finder = finders.new_async_job({
      command_generator = function()
        return { 'docker', 'ps', '--format', 'json' }
      end,
      entry_maker = function(entry)
        local parsed = vim.json.decode(entry)
        if parsed then
          local image_name = parsed.Image .. ':' .. parsed.Names
          return {
            value = parsed,
            display = image_name,
            ordinal = image_name,
          }
        end
      end
    }),
    sorter = conf.generic_sorter(opts),
    previewer = previewers.new_buffer_previewer({
      title = "Docker Container Details",
      define_preview = function(self, entry)
        vim.api.nvim_buf_set_lines(self.state.bufnr, 0, 0, true, vim.iter({
          '# ' .. entry.value.ID,
          '```lua',
          vim.split(vim.inspect(entry.value), '\n'),
          '```',
        }):flatten():totable())
        previewers_utils.highlighter(self.state.bufnr, "markdown")
      end,
    }),
    attach_mappings = function(prompt_bufnr, _)
      local docker_exec = function(window_orientation)
        return function()
          local selection = action_state.get_selected_entry()
          actions.close(prompt_bufnr)
          local cmd = vim.fn.input({ prompt = "Command to execute: ", default = 'sh' })
          vim.cmd(string.format('%s term://docker exec -it %s %s', window_orientation, selection.value.Names, cmd))
        end
      end
      actions.select_default:replace(docker_exec('edit'))
      actions.select_horizontal:replace(docker_exec('new'))
      actions.select_vertical:replace(docker_exec('vnew'))
      actions.select_tab:replace(docker_exec('tabedit'))
      return true
    end
  }):find()
end

-- vim.keymap.set('n', '<leader>rt', M.find_docker_containers)
-- vim.keymap.set('n', '<leader>rr', ':update | luafile %<cr>')

return M
