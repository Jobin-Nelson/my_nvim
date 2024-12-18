local jira = require('jobin.config.custom.work_stuff.jira')

local M = {}

---@param filter_id string
---@return FilterResult
local function filter(filter_id)
  return vim.json.decode(jira.request(
     ('https://jira.illumina.com/rest/api/2/filter/%s')
      :format(filter_id), {}))
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
---@param max_results integer
---@param fields string[]
---@return Issue[]
local function get_search_results(jql, max_results, fields)
  local data = {
    ["jql"] = jql,
    ["maxResults"] = max_results,
    ["fields"] = fields,
  }
  return search(vim.json.encode(data)).issues
end


---@param issue Issue
---@return string
function M.issue2line(issue)
  return ('- [%s] %s'):format(issue.key, issue.fields.summary)
end

---@param issues Issue[]
local function list_issue_summary(issues)
  local lines = vim.tbl_map(M.issue2line, issues)
  local line_nr = vim.fn.line('.')
  vim.api.nvim_buf_set_lines(0, line_nr, line_nr, false, lines)
end

function M.list_filter_issues()
  vim.ui.input({ prompt = 'Enter filter ID: ' }, function(filter_id)
    if not filter_id or filter_id == '' then
      return jira.notify('Invalid filter_id entered')
    end
    local filter_jql = get_filter_jql(filter_id)
    local search_results = get_search_results(filter_jql, 100, { 'summary' })
    if not search_results then
      return jira.notify('No issues found for this filter', vim.log.levels.WARN)
    end
    list_issue_summary(search_results)
  end)
end


-- vim.keymap.set('n', '<leader>rt', M.populate_issue)
-- vim.keymap.set('n', '<leader>rr', ':update | luafile %<cr>')
return M