-- https://docs.atlassian.com/software/jira/docs/api/REST/8.20.14/
-- https://luals.github.io/wiki/annotations/

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
---@field subtasks SubTask[]

---@class SubTask
---@field key string
---@field fields SubTaskField

---@class SubTaskField
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
function M.request_jira(url, additional_headers, data)
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

-- vim.keymap.set('n', '<leader>rt', M.populate_issue)
-- vim.keymap.set('n', '<leader>rr', ':update | luafile %<cr>')
return M
