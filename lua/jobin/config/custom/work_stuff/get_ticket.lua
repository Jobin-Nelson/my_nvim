-- https://docs.atlassian.com/software/jira/docs/api/REST/8.20.14/


-- ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
-- ┃                          Types                           ┃
-- ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛


---@class Creds
---@field jira Jira

---@class Jira
---@field link string
---@field token string

---@class Issue
---@field key string
---@field fields IssueField

---@class IssueField
---@field summary string
---@field issuetype IssueType
---@field description string

---@class IssueType
---@field id integer


-- ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
-- ┃                   Core Implementation                    ┃
-- ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛


local M = {}

---@return string
local function get_token()
  local creds_file_path = vim.fs.normalize('~/playground/dev/illumina/creds/jira.json')
  ---@type Creds
  local creds = vim.fn.json_decode(vim.fn.readfile(creds_file_path))
  if not creds then
    error('No jira.json file found')
  end
  local token = creds.jira and creds.jira.token
  if not token then
    error('Cannot parse jira.json file')
  end
  return token
end

---@param url string
---@param additional_headers string[]?
---@param data string?
---@return string
local function request_jira(url, additional_headers, data)
  local token = get_token()
  local cmd = { 'curl' }
  -- flags
  table.insert(cmd, '-sSfL')
  local headers = {
    'Authorization: Bearer ' .. token,
    'Content-Type: application/json'
  }
  vim.list_extend(headers, additional_headers or {})
  vim.tbl_map(
    function(header) vim.list_extend(cmd, { '--header', header }) end,
    headers
  )
  -- POST request data
  if data then
    vim.tbl_map(
      function(arg) table.insert(cmd, arg) end,
      { '-X', 'POST', '-d', data }
    )
  end

  -- request url
  table.insert(cmd, url)

  local response = vim.system(cmd, { text = true }):wait()
  if response.stdout == nil then
    error('Jira request failed')
  end

  return response.stdout
end

---@param lines string[]
---@param subtasks Issue[]
local function append_subtasks(lines, subtasks)
  if #subtasks == 0 then
    vim.notify('Issue %s does not have subtasks')
    return
  end
  table.insert(lines, '** Sub-Tasks')
  for _, subtask in ipairs(subtasks) do
    local subtask_summary = subtask.fields and subtask.fields.summary
    local is_bug = subtask.fields and subtask.fields.issuetype and subtask.fields.issuetype.id == '14'
    if subtask_summary then
      local line = string.format('*** TODO [%s] %s', subtask.key, subtask_summary)
      if is_bug then
        line = line .. ' :BUG:'
      end
      table.insert(lines, line)
    end
  end
end

---@param lines string[]
---@param fields IssueField
---@param issue_id string
local function append_header(lines, fields, issue_id)
  local heading = '* TODO ' .. fields.summary
  ---@diagnostic disable-next-line: undefined-field
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
    return
  end

  table.insert(lines, '** Description')
  vim.tbl_map(
    function(description_line)
      local function jira_list2org_list(hash)
        return string.rep(' ', #hash - 1) .. '- '
      end
      local sanitized_line = description_line
          :gsub('\r', '')                         -- remove carriage return
          :gsub('{%*}', '*')                      -- remove curly braces
          :gsub('^(%s*#+) ', jira_list2org_list)  -- jira numbered list to org list
          :gsub('^(%s*%*+) ', jira_list2org_list) -- jira list to org list

      table.insert(lines, '   ' .. sanitized_line)
    end,
    vim.split(fields.description, '\n')
  )
end

---@param issue_id string
local function populate_issue_details(issue_id)
  if issue_id == nil or issue_id == '' then
    return vim.notify(
      'ERROR: Received invalid issue id',
      vim.log.levels.ERROR,
      { title = 'Jira' }
    )
  end

  local get_issue_query = string.format(
    'https://jira.illumina.com/rest/api/2/issue/%s?fields=summary,description,issuetype,subtasks',
    issue_id
  )
  local response = vim.json.decode(request_jira(get_issue_query, {}))
  if not response or not response.fields then
    error('api response is not json')
  end

  local lines = {}
  append_header(lines, response.fields, issue_id)
  append_subtasks(lines, response.fields.subtasks)

  local line_nr = vim.fn.line('.')
  vim.api.nvim_buf_set_lines(0, line_nr, line_nr, false, lines)
end

M.populate_issue = function()
  vim.ui.input({
    prompt = 'Enter Issue ID: ',
  }, populate_issue_details)
end

---@param filter_id string
---@return string
local function get_filter_jql(filter_id)
  local get_filter_query = string.format(
    'https://jira.illumina.com/rest/api/2/filter/%s',
    filter_id
  )
  local response = vim.json.decode(request_jira(get_filter_query, {}))
  local filter_jql = response and response.jql
  if filter_jql == nil then
    error('received nil filter jql')
  end
  return filter_jql
end

---@param jql string
---@param max_results integer
---@param fields string[]
local function get_search_results(jql, max_results, fields)
  local get_search_query = 'https://jira.illumina.com/rest/api/2/search'
  local data = {
    ["jql"] = jql,
    ["maxResults"] = max_results,
    ["fields"] = fields,
  }
  local json_data = vim.json.encode(data)

  local response = vim.json.decode(request_jira(get_search_query, {}, json_data))
  local issues = response and response.issues
  if issues == nil then
    error('No issues found for this filter')
  end

  return issues
end

---@param issues Issue[]
local function list_issue_summary(issues)
  local lines = vim.tbl_map(function(issue)
    return ('- [%s] %s'):format(issue.key, issue.fields.summary)
  end, issues)

  local line_nr = vim.fn.line('.')
  vim.api.nvim_buf_set_lines(0, line_nr, line_nr, false, lines)
end

M.list_filter_issues = function()
  vim.ui.input({ prompt = 'Enter filter ID: ' }, function(filter_id)
    if filter_id == nil or filter_id == '' then
      return vim.notify(
        'Invalid filter_id entered',
        vim.log.levels.ERROR,
        { title = 'Jira' }
      )
    end
    local filter_jql = get_filter_jql(filter_id)
    local search_results = get_search_results(filter_jql, 100, { 'summary' })
    list_issue_summary(search_results)
  end)
end


-- vim.keymap.set('n', '<leader>rt', M.populate_issue)
-- vim.keymap.set('n', '<leader>rr', ':update | luafile %<cr>')
return M
