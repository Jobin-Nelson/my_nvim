local jira = require('jobin.config.custom.work_stuff.jira')

local M = {}

---@param filter_id string
---@return string
local function get_filter_jql(filter_id)
  local get_filter_query = string.format(
    'https://jira.illumina.com/rest/api/2/filter/%s',
    filter_id
  )
  local response = vim.json.decode(jira.request(get_filter_query, {}))
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

  local response = vim.json.decode(jira.request(get_search_query, {}, json_data))
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

function M.list_filter_issues()
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
