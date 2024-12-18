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

---@class LocalTask
---@field key string
---@field summary string

---@alias RLTask SubTask | LocalTask

---@class SearchResult
---@field issues Issue[]

---@class FilterResult
---@field jql string


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

---@param line string
---@return string? id
---@return string? summary
function M.get_id_summary(line)
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

---@param line string
---@return LocalTask
function M.line2Localtask(line)
  local id, summary = M.get_id_summary(line)
  return { key = id, summary = summary }
end

---@param task SubTask
---@return string
function M.task2Todo(task)
    local line = string.format('*** TODO [%s] %s', task.key, task.fields.summary)
    if task.fields.issuetype.id == '14' then
      line = line .. ' :BUG:'
    end
    return line
end

---@param issue Issue
---@return string
function M.issue2List(issue)
  return ('- [%s] %s'):format(issue.key, issue.fields.summary)
end


---@param msg string
---@param level? integer
function M.notify(msg, level)
  vim.notify(
    msg,
    level or vim.log.levels.ERROR,
    { title = 'Jira' }
  )
end


-- vim.keymap.set('n', '<leader>rt', function() M.request('https://google.com') end)
-- vim.keymap.set('n', '<leader>rr', ':update | luafile %<cr>')
return M
