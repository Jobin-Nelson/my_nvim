local jira = require('jobin.config.custom.work_stuff.jira')
local jira_search = require('jobin.config.custom.work_stuff.jira.search')

local M = {}

---@param issue_id string
---@return SubTask[]
local function get_remote_subtask(issue_id)
  return vim.json.decode(jira.request(
    ('https://jira.illumina.com/rest/api/2/issue/%s/subtask'):format(issue_id)
  ))
end

---@param issue_id string
---@return Issue[]
function M.get_my_remote_subtask(issue_id)
  return jira_search.query_jql(
    ('parent = %s and assignee = currentUser()'):format(issue_id),
    100,
    { 'summary', 'issuetype' }
  )
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
---@param cur_head_nr integer
---@return LocalTask[] local_subtasks
local function get_local_subtask(cur_line_nr, cur_head_nr)
  local sub_task_line_nr, sub_task_line = jira.child_match(
    cur_line_nr, cur_head_nr, '^%*+ Sub%-Tasks'
  )
  if not (sub_task_line_nr and sub_task_line) then
    jira.notify('No Subtask found below cursor', vim.log.levels.INFO)
    return {}
  end
  local sub_task_header_nr = #sub_task_line:match('^(%*+)')
  return vim.tbl_map(jira.line2localtask,
    jira.child_matches(
      sub_task_line_nr,
      sub_task_header_nr,
      ('^%s '):format(('%*'):rep(sub_task_header_nr + 1))
    )
  )
end

function M.get()
  local cur_line_nr, cur_line = vim.fn.line('.'), vim.api.nvim_get_current_line()
  if not cur_line:match('^%*+ %w+') then
    return jira.notify('Cursor not on a heading')
  end
  local issue_id = jira.get_id_summary(cur_line)
  if not issue_id then
    return jira.notify('Current heading has no issue id')
  end
  local cur_head_nr = #cur_line:match('^(%*+)')
  local lines = vim.tbl_map(jira.task2todo, missing_subtasks(
    M.get_my_remote_subtask(issue_id),
    get_local_subtask(cur_line_nr, cur_head_nr)
  ))
  local sub_task_line_nr = jira.child_match(
    cur_line_nr, cur_head_nr, '^%*+ Sub%-Tasks'
  ) or cur_line_nr
  vim.api.nvim_buf_set_lines(0, sub_task_line_nr, sub_task_line_nr, false, lines)
end

-- vim.keymap.set('n', '<leader>rt', function() M.get() end)
-- vim.keymap.set('n', '<leader>rr', ':update | luafile %<cr>')
return M
