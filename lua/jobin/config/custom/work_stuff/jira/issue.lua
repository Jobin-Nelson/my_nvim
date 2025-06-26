local jira = require('jobin.config.custom.work_stuff.jira')
local jira_subtask = require('jobin.config.custom.work_stuff.jira.subtask')

local M = {}

---@param fields IssueField
---@param issue_id string
---@return string[]
local function get_header_lines(fields, issue_id)
  local heading = ('* TODO [%s] %s'):format(issue_id, fields.summary)
  if fields.issuetype and fields.issuetype.id == '1' then
    heading = heading .. ' :BUG:'
  end
  local lines = { heading, os.date('  SCHEDULED: <%Y-%m-%d %a>'), }

  if fields.description == vim.NIL then
    return lines
  end

  table.insert(lines, '** Description')
  local function jira_list2org_list(hash)
    return string.rep(' ', #hash - 1) .. '- '
  end
  return vim.list_extend(lines, vim.tbl_map(
    function(description_line)
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
  return vim.json.decode(jira.request(string.format(
    '%s/rest/api/2/issue/%s?fields=summary,description,issuetype',
    jira.get_domain(),
    issue_id
  )))
end

---@param subtasks SubTask[]
local function get_subtask_lines(subtasks)
  local subtask_lines = vim.tbl_map(jira.task2todo, subtasks)
  return vim.tbl_isempty(subtask_lines)
      and subtask_lines
      or vim.list_extend({ '** Sub-Tasks' }, subtask_lines)
end

---@param issue_id string
local function populate_issue_details(issue_id)
  local response = get_issue(issue_id)
  local lines = vim.iter({
    get_header_lines(response.fields, issue_id),
    get_subtask_lines(jira_subtask.get_my_remote_subtask(issue_id)),
  }):flatten():totable()

  local line_nr = vim.fn.line('.')
  vim.api.nvim_buf_set_lines(0, line_nr, line_nr, false, lines)
end

function M.get()
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

---@param line string
function M.open(line)
  local id = jira.get_id(line)
  if not id then
    return jira.notify('Ticket ID not present in current line')
  else
    jira.notify(('Opening issue %s'):format(id), vim.log.levels.INFO)
  end
  vim.ui.open(('%s/browse/%s'):format(jira.get_domain(), id)):wait()
end

-- vim.keymap.set('n', '<leader>rt', M.get)
-- vim.keymap.set('n', '<leader>rr', ':update | luafile %<cr>')
return M
