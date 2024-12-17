local jira = require('jobin.config.custom.work_stuff.jira')

local M = {}

---@param issue_id string
---@return SubTask[]
local function get_subtask(issue_id)
  return vim.json.decode(jira.request_jira(
    ('https://jira.illumina.com/rest/api/2/issue/%s/subtask'):format(issue_id)
  ))
end


---@param line string
---@return string? id
---@return string summary
local function get_id_summary(line)
  local summary = line:match('^%*+ %w+%s+(.*)$')
  local id = summary:match('^%[([^%]]*)')
  if id then
    summary = summary:sub(#id+2)
  end
  return id, summary
end

function M.create()
  vim.ui.input({ prompt = 'Enter Issue ID: ', },
    function(issue_id)
      if issue_id == nil or issue_id == '' then
        return vim.notify(
          'ERROR: Received invalid issue id',
          vim.log.levels.ERROR,
          { title = 'Jira' }
        )
      end
      local cur_line = vim.fn.getline('.')
      if not cur_line:match('^%*+ ') then
        return vim.notify(
          'Cursor not on a heading',
          vim.log.levels.ERROR,
          { title = 'Jira' }
        )
      end
      local subtasks = get_subtask(issue_id)
      local id, summary = get_id_summary(cur_line)
      if vim.iter(subtasks):any(function(task)
        return id and task.key == id or task.fields.summary == summary
      end) then
        vim.print('Subtask already present')
      else
        vim.print('Subtask not present')
      end
    end)
end

vim.keymap.set('n', '<leader>rt', M.create)
vim.keymap.set('n', '<leader>rr', ':update | luafile %<cr>')
return M
