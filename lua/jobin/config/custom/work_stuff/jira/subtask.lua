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
---@return LocalTask[]
local function get_local_subtask(cur_line_nr)
  local sub_task_line_nr, sub_task_line = vim.iter(ipairs(
    vim.api.nvim_buf_get_lines(0, cur_line_nr, -1, false)
  )):find(function(_, l) return l:match('^%*+ Sub%-Tasks') end)
  if not sub_task_line then
    jira.notify('No Subtask found below cursor', vim.log.levels.WARN)
    return {}
  end
  sub_task_line_nr = sub_task_line_nr + cur_line_nr
  local till_line = string.format('^%s ', string.rep('%*',
    #sub_task_line:match('^(%*+) Sub%-Tasks') + 1))
  local till_line_nr = vim.iter(ipairs(
    vim.api.nvim_buf_get_lines(0, sub_task_line_nr, -1, false)
  )):find(function(_, l) return l:match(till_line) end) or -1
  return vim.iter(vim.api.nvim_buf_get_lines(0, sub_task_line_nr, till_line_nr, false))
      :filter(function(l) return l:match(till_line) end)
      :totable()
end
-- ---@param cur_line_nr integer
-- ---@return LocalTask[]
-- local function get_local_subtask(cur_line_nr)
--   -- No escape from imperative here :(
--   local local_subtasks = {}
--   local line_nr = 0
--   local file = io.open(vim.fn.expand('%:p'))
--   if not file then
--     error('ERROR: Could not open file')
--   end
--   for _ in file:lines() do
--     line_nr = line_nr + 1
--     if line_nr == cur_line_nr then
--       break
--     end
--   end
--   local heading_nr = 0
--   for line in file:lines() do
--     if line:match('^%*+ Sub%-Tasks') then
--       heading_nr = #line:match('^(%*+) Sub%-Tasks')
--       break
--     end
--   end
--   vim.print(heading_nr)
--   for line in file:lines() do
--     if line:match('^%*+ %w+ ') then
--       if #line:match('^(%*+)') < heading_nr then
--         break
--       end
--       if line:match(('^%s '):format(('%*'):rep(heading_nr + 1))) then
--         table.insert(local_subtasks, line)
--       end
--     end
--   end
--   file:close()
--   return vim.tbl_map(function(l)
--       local id, summary = get_id_summary(l)
--       return { key = id, summary = summary }
--     end,
--     local_subtasks)
-- end

---@param tasks SubTask[]
---@return string[]
function M.subtasks2lines(tasks)
  if vim.tbl_isempty(tasks) then
    jira.notify('Issue %s does not have subtasks')
    return {}
  end
  return vim.tbl_map(function(task)
    local line = string.format('*** TODO [%s] %s', task.key, task.fields.summary)
    if task.fields.issuetype.id == '14' then
      line = line .. ' :BUG:'
    end
    return line
  end, tasks)
end

function M.create_local()
  local cur_line, cur_line_nr = vim.fn.getline('.'), vim.fn.line('.')
  if not cur_line:match('^%*+ %w+') then
    return jira.notify('Cursor not on a heading')
  end
  local issue_id = get_id_summary(cur_line)
  if not issue_id then
    return jira.notify('Invalid issue id received')
  end
  local lines = M.subtasks2lines(missing_subtasks(
    get_remote_subtask(issue_id),
    get_local_subtask(cur_line_nr)
  ))
  vim.api.nvim_buf_set_lines(0, cur_line_nr, cur_line_nr, false, lines)
  -- if vim.iter(subtasks):any(function(task)
  --       return issue_id and task.key == issue_id or task.fields.summary == summary
  --     end) then
  --   vim.print('Subtask already present')
  -- else
  --   vim.print('Subtask not present')
  -- end
end

vim.keymap.set('n', '<leader>rt', function() M.create_local() end)
vim.keymap.set('n', '<leader>rr', ':update | luafile %<cr>')
return M
