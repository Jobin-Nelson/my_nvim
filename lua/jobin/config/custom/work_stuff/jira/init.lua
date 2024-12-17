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
function M.request(url, additional_headers, data)
  local default_headers = {
    'Authorization: Bearer ' .. get_token(),
    'Content-Type: application/json'
  }
  local headers = vim.iter(vim.tbl_map(
    function(header) return { '--header', header } end,
    vim.list_extend(default_headers, additional_headers or {})
  )):flatten():totable()

  -- POST request data
  if data then
    vim.list_extend(headers, { '-X', 'POST', '-d', data })
  end

  local cmd = vim.iter({
    { 'curl', '-sSfL' }, -- flags
    headers,             -- headers + data?
    { url }              -- query url
  }):flatten():totable()

  local response = vim.system(cmd, { text = true }):wait()
  if response.code ~= 0 or response.stdout == nil then
    error('Jira request failed')
  end

  return response.stdout
end

-- vim.keymap.set('n', '<leader>rt', function() M.request('https://google.com') end)
-- vim.keymap.set('n', '<leader>rr', ':update | luafile %<cr>')
return M
