-- https://support.atlassian.com/jira-service-management-cloud/docs/use-advanced-search-with-jira-query-language-jql/

local jira = require('jobin.config.custom.work_stuff.jira')

local M = {}

---@param filter_id string
---@return FilterResult
local function filter(filter_id)
  return vim.json.decode(jira.request(
    ('https://jira.illumina.com/rest/api/2/filter/%s')
    :format(filter_id), {}
  ))
end

---@param filter_id string
---@return string
local function get_filter_jql(filter_id)
  return filter(filter_id).jql
end

---@param json_data string
---@return SearchResult
local function search(json_data)
  return vim.json.decode(jira.request('https://jira.illumina.com/rest/api/2/search', {}, json_data))
end

---@param jql string
---@param max_results integer?
---@param fields string[]?
---@return Issue[]
function M.query_jql(jql, max_results, fields)
  local data = {
    ["jql"] = jql,
    ["startAt"] = 0,
    ["maxResults"] = max_results or 100,
    ["fields"] = fields or { 'summary' },
  }
  return search(vim.json.encode(data)).issues
end

---@param jql string
---@param max_results integer?
function M.query_jql2list(jql, max_results)
  return vim.tbl_map(jira.issue2List, M.query_jql(jql, max_results or 100))
end

function M.query()
  local jql = vim.fn.input({
    prompt = 'JQL > ',
    default = 'status not in (Done,Closed) AND assignee in (currentUser())',
  })
  if jql == '' then return end

  local results = M.query_jql2list(jql)
  if vim.tbl_isempty(results) then
    return jira.notify(('No issues found for JQL: %s'):format(jql), vim.log.levels.WARN)
  end
  local cur_line = vim.fn.line('.')
  vim.api.nvim_buf_set_lines(0,
    cur_line,
    cur_line,
    false,
    results
  )
end

function M.list_filter_issues()
  vim.ui.input({ prompt = 'Enter filter ID: ' }, function(filter_id)
    if not filter_id or filter_id == '' then
      return jira.notify('Invalid filter_id entered')
    end
    local filter_jql = get_filter_jql(filter_id)
    local search_results = M.query_jql2list(filter_jql)
    if vim.tbl_isempty(search_results) then
      return jira.notify(('No issues found for filter: %s'):format(filter_id), vim.log.levels.WARN)
    end
    local line_nr = vim.fn.line('.')
    vim.api.nvim_buf_set_lines(0,
      line_nr,
      line_nr,
      false,
      search_results
    )
  end)
end

-- vim.keymap.set('n', '<leader>rt', M.populate_issue)
-- vim.keymap.set('n', '<leader>rr', ':update | luafile %<cr>')
return M
