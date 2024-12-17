local jira = require('jobin.config.custom.work_stuff.jira')

local M = {}

---@param issue_id string
---@return SubTask[]
local function get_subtask(issue_id)
  return vim.json.decode(jira.request(
    ('https://jira.illumina.com/rest/api/2/issue/%s/subtask'):format(issue_id)
  ))
end

---@param line string
---@return string? id
---@return string? summary
local function get_id_summary(line)
  local words = vim.split(line, ' ')
  local id = vim.iter(words)
      :take(4)
      :map(function(word) return word:match('^%[([^#%]]*)%]$') end)
      :find(function(word) return word end)
  local summary_index = vim.iter(ipairs(words))
      :skip(2)
      :find(function(_, word) return not word:match('^%[') end)
  if not summary_index then
    return id, nil
  end
  return id, line:sub(vim.iter(words)
    :take(summary_index - 1)
    :fold(1, function(acc, word) return acc + #word + 1 end))
end

function M.create()
  vim.ui.input({ prompt = 'Enter Issue ID: ', },
    function(issue_id)
      if issue_id == nil or issue_id == '' then
        return vim.notify(
          'Invalid issue id received',
          vim.log.levels.ERROR,
          { title = 'Jira' }
        )
      end
      local cur_line = vim.fn.getline('.')
      if not cur_line:match('^%*+ %w+') then
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

-- vim.keymap.set('n', '<leader>rt', function() get_id_summary(vim.fn.getline('.')) end)
-- vim.keymap.set('n', '<leader>rr', ':update | luafile %<cr>')
return M
