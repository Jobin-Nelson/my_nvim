local jira = require('jobin.config.custom.work_stuff.jira')

local M = {}

---@param issue_id string
---@return SubTask[]
local function get_remote_subtask(issue_id)
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

---@param left_subtasks RLTask[]
---@param right_subtasks RLTask[]
---@param is_right? boolean
---@return RLTask[]
local function missing_subtasks(left_subtasks, right_subtasks, is_right)
  if is_right then
    left_subtasks, right_subtasks = right_subtasks, left_subtasks
  end
  return vim.iter(left_subtasks)
      :filter(function(ltask)
        return vim.iter(right_subtasks):find(function(rtask)
          return rtask.key == ltask.key
        end) == nil
      end)
      :totable()
end

---@param cur_line_nr integer
---@return integer? sub_task_line_nr
---@return string? sub_task_line
local function get_subtask_header(cur_line_nr)
  local sub_task_line_nr, sub_task_line = vim.iter(ipairs(
    vim.api.nvim_buf_get_lines(0, cur_line_nr, -1, false)
  )):find(function(_, l) return l:match('^%*+ Sub%-Tasks') end)
  if not sub_task_line then
    return nil, nil
  end
  sub_task_line_nr = sub_task_line_nr + cur_line_nr
  return sub_task_line_nr, sub_task_line
end

---@param line string
---@return LocalTask[]
local function line2subtask(line)
  local id, summary = get_id_summary(line)
  return { key = id, summary = summary }
end

---@param cur_line_nr integer
---@return LocalTask[] local_subtasks
local function get_local_subtask(cur_line_nr)
  local sub_task_line_nr, sub_task_line = get_subtask_header(cur_line_nr)
  if not (sub_task_line_nr and sub_task_line) then
    jira.notify('No Subtask found below cursor', vim.log.levels.INFO)
    return {}
  end
  local sub_task_header_nr = #sub_task_line:match('^(%*+)')
  local local_sub_task_header = string.format('^%s ', string.rep('%*', sub_task_header_nr + 1))
  -- look till a line with equal or bigger heading than the sub task heading
  local till_line_nr = vim.iter(ipairs(
    vim.api.nvim_buf_get_lines(0, sub_task_line_nr, -1, false)
  )):find(function(_, l)
    return l:match('^%*+ %w+') and #l:match('^(%*+)') <= sub_task_header_nr
  end)
  till_line_nr = till_line_nr and sub_task_line_nr + till_line_nr or -1
  return vim.iter(vim.api.nvim_buf_get_lines(0, sub_task_line_nr, till_line_nr, false))
      :filter(function(l) return l:match(local_sub_task_header) end)
      :map(line2subtask)
      :totable()
end

---@param task SubTask
---@return string
function M.subtask2line(task)
    local line = string.format('*** TODO [%s] %s', task.key, task.fields.summary)
    if task.fields.issuetype.id == '14' then
      line = line .. ' :BUG:'
    end
    return line
end

function M.get()
  local cur_line, cur_line_nr = vim.fn.getline('.'), vim.fn.line('.')
  if not cur_line:match('^%*+ %w+') then
    return jira.notify('Cursor not on a heading')
  end
  local issue_id = get_id_summary(cur_line)
  if not issue_id then
    return jira.notify('Invalid issue id received')
  end
  local lines = vim.tbl_map(M.subtask2line, missing_subtasks(
    get_remote_subtask(issue_id),
    get_local_subtask(cur_line_nr)
  ))
  local sub_task_line_nr = get_subtask_header(cur_line_nr) or cur_line_nr
  vim.api.nvim_buf_set_lines(0, sub_task_line_nr, sub_task_line_nr, false, lines)
end

-- vim.keymap.set('n', '<leader>rt', function() M.get() end)
-- vim.keymap.set('n', '<leader>rr', ':update | luafile %<cr>')
return M
