vim.api.nvim_create_user_command('DiffOrig', function()
  local start = vim.api.nvim_get_current_buf()
  vim.cmd('vnew | set buftype=nofile | read ++edit # | 0d_ | diffthis')
  local scratch = vim.api.nvim_get_current_buf()

  vim.cmd('wincmd p | diffthis')

  -- Map `q` for both buffers to exit diff view and delete scratch buffer
  for _, buf in ipairs({ scratch, start }) do
    vim.keymap.set('n', 'q', function()
      vim.api.nvim_buf_delete(scratch, { force = true })
      vim.keymap.del('n', 'q', { buffer = start })
    end, { buffer = buf })
  end
end, {})

-- Todoist
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
  vim.system(vim.list_extend({ 'todo.py' }, utils.shellsplit(opts.args)), {}, notify)
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

-- Jira
vim.api.nvim_create_user_command('JQL', function(opts)
    require('jobin.config.custom.fzf.pickers').fzf_search_jira(opts.args)
  end, { nargs = 1 }
)

-- HTop
vim.api.nvim_create_user_command('Htop', function(_)
    require('jobin.config.custom.utils').wrap_cli({ 'htop' })
  end, { nargs = 0 }
)

-- Github cli dash
vim.api.nvim_create_user_command('Gdash', function(_)
    require('jobin.config.custom.utils').wrap_cli({ 'gh', 'dash' })
  end, { nargs = 0 }
)
