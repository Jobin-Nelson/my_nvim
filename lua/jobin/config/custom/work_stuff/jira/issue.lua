local jira = require('jobin.config.custom.work_stuff.jira')

local M = {}

---@param tasks SubTask[]
---@return string[]
local function subtasks(tasks)
  local lines = {}
  if #tasks == 0 then
    vim.notify(
      'Issue %s does not have subtasks',
      vim.log.levels.INFO,
      { title = 'Jira' }
    )
    return lines
  end
  table.insert(lines, '** Sub-Tasks')
  return vim.list_extend(lines, vim.tbl_map(
    function(task)
      local subtask_summary = task.fields and task.fields.summary
      local is_bug = task.fields and task.fields.issuetype and task.fields.issuetype.id == '14'
      if subtask_summary then
        local line = string.format('*** TODO [%s] %s', task.key, subtask_summary)
        if is_bug then
          line = line .. ' :BUG:'
        end
        return line
      end
    end,
    tasks
  ))
end

---@param fields IssueField
---@param issue_id string
---@return string[]
local function header(fields, issue_id)
  local lines = {}
  local heading = '* TODO ' .. fields.summary
  if fields.issuetype and fields.issuetype.id == '1' then
    heading = heading .. ' :BUG:'
  end
  vim.list_extend(lines, {
    heading,
    os.date('  SCHEDULED: <%Y-%m-%d %a>'),
    '  :PROPERTIES:',
    ('  :Ticket: %s'):format(issue_id),
    '  :END:'
  })

  if fields.description == vim.NIL then
    return lines
  end

  table.insert(lines, '** Description')
  return vim.list_extend(lines, vim.tbl_map(
    function(description_line)
      local function jira_list2org_list(hash)
        return string.rep(' ', #hash - 1) .. '- '
      end
      return '   ' .. description_line
          :gsub('\r', '')                         -- remove carriage return
          :gsub('{%*}', '*')                      -- remove curly braces
          :gsub('^(%s*#+) ', jira_list2org_list)  -- jira numbered list to org list
          :gsub('^(%s*%*+) ', jira_list2org_list) -- jira list to org list
    end,
    vim.split(fields.description, '\n')
  ))
end


---@param issue_id string
---@return Issue
local function get_issue(issue_id)
  return vim.json.decode(jira.request_jira(string.format(
    'https://jira.illumina.com/rest/api/2/issue/%s?fields=summary,description,issuetype,subtasks',
    issue_id
  )))
end

---@param issue_id string
local function populate_issue_details(issue_id)
  local response = get_issue(issue_id)
  local lines = vim.iter({
    header(response.fields, issue_id),
    subtasks(response.fields.subtasks)
  }):flatten():totable()

  local line_nr = vim.fn.line('.')
  vim.api.nvim_buf_set_lines(0, line_nr, line_nr, false, lines)
end

function M.populate_issue()
  vim.ui.input({
    prompt = 'Enter Issue ID: ',
  }, function(issue_id)
    if issue_id == nil or issue_id == '' then
      return vim.notify(
        'ERROR: Received invalid issue id',
        vim.log.levels.ERROR,
        { title = 'Jira' }
      )
    end
    populate_issue_details(issue_id)
  end)
end

-- vim.keymap.set('n', '<leader>rt', M.populate_issue)
-- vim.keymap.set('n', '<leader>rr', ':update | luafile %<cr>')
return M
