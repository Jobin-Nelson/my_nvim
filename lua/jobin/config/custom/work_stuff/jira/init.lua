-- https://docs.atlassian.com/software/jira/docs/api/REST/8.20.14/
-- https://luals.github.io/wiki/annotations/


-- ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
-- ┃                          Types                           ┃
-- ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛


---@class Creds
---@field jira Jira

---@class Jira
---@field token string
---@field domain string

---@class Issue
---@field key string
---@field fields IssueField

---@class IssueField
---@field summary string
---@field status { name: string }
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

local utils = require('jobin.config.custom.utils')

local M = {}

---@type Creds?
local _creds = nil

---@return Creds
local function get_creds()
  if not _creds then
    local creds_file_path = vim.fs.normalize('~/playground/dev/illumina/creds/jira.json')
    ---@type Creds
    _creds = vim.fn.json_decode(vim.fn.readfile(creds_file_path))
    vim.validate({
      jira = { _creds.jira, 'table' },
      token = { _creds.jira.token, 'string' },
      domain = { _creds.jira.domain, 'string' },
    })
  end
  return _creds
end

---@return string
function M.get_domain()
  local creds = get_creds()
  return creds.jira.domain
end

---@return string
local function get_token()
  local creds = get_creds()
  return creds.jira.token
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
  local headers = vim.iter(vim.list_extend(default_headers, additional_headers or {}))
      :map(function(header) return { '--header', header } end)
      :flatten()
      :totable()

  local response = utils.request(url, headers, data)
  if response.code ~= 0 or response.stdout == nil then
    error(([[Jira request failed
    STDOUT: %s
    STDERR: %s
    ]]):format(response.stdout, response.stderr))
  end

  return response.stdout
end

---@param line string
---@return string? id
function M.get_id(line)
  return line:match('%[([A-Z]+%-%d+)%]')
end

---@param line string
---@return string? id
---@return string? summary
function M.get_id_summary(line)
  local id = M.get_id(line)
  local words = vim.split(line, ' ')
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
function M.line2localtask(line)
  local id, summary = M.get_id_summary(line)
  return { key = id, summary = summary }
end

---@param task SubTask
---@return string
function M.task2todo(task)
  local line = string.format('*** TODO [%s] %s', task.key, task.fields.summary)
  if task.fields.issuetype.id == '14' then
    line = line .. ' :BUG:'
  end
  return line
end

---@param issue Issue
---@return string
function M.issue2list(issue)
  return ('- [%s] %s'):format(issue.key, issue.fields.summary)
end

---@param issue Issue
---@return string
function M.issue2List_with_status(issue)
  return ('- [%s] [%s] %s'):format(issue.key, issue.fields.status.name, issue.fields.summary)
end

---@param cur_line_nr integer
---@param header_nr integer
---@return integer? line_nr the next sib/ancSib line number
---@return string?  line    the next sib/ancSib line
function M.next_sibling_or_ancestor_sibling(cur_line_nr, header_nr)
  local next_sibling_line_nr, next_sibling_line = vim.iter(ipairs(
    vim.api.nvim_buf_get_lines(0, cur_line_nr, -1, false)
  )):find(function(_, l)
    -- look till a line with equal or bigger heading than the header_nr
    return l:match('^%*+ %w+') and #l:match('^(%*+)') <= header_nr
  end)
  return next_sibling_line_nr and next_sibling_line_nr + cur_line_nr, next_sibling_line
end

---@param cur_line_nr integer
---@param cur_head_nr integer
---@param line_reg string
---@return integer? child_nr  the child line number
---@return string? child_line the child line that matched line_reg
function M.child_match(cur_line_nr, cur_head_nr, line_reg)
  local child_nr, child_line = vim.iter(ipairs(
    vim.api.nvim_buf_get_lines(0, cur_line_nr,
      M.next_sibling_or_ancestor_sibling(cur_line_nr, cur_head_nr) or -1,
      false)
  )):find(function(_, l) return l:match(line_reg) end)
  return child_nr and child_nr + cur_line_nr, child_line
end

---@param cur_line_nr integer
---@param cur_head_nr integer
---@param line_reg string
---@return string[] child_lines list of child lines that matched line_reg
function M.child_matches(cur_line_nr, cur_head_nr, line_reg)
  return vim.tbl_filter(
    function(l) return l:match(line_reg) end,
    vim.api.nvim_buf_get_lines(0, cur_line_nr,
      M.next_sibling_or_ancestor_sibling(cur_line_nr, cur_head_nr) or -1,
      false))
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

---@param line string
function M.copy_id(line)
  local id = M.get_id(line)
  if not id then
    return M.notify('No issue id found in line')
  else
    M.notify(('Copied issue id: %s'):format(id), vim.log.levels.INFO)
  end
  vim.fn.setreg('+', id)
end

-- vim.keymap.set('n', '<leader>rt', function() M.request('https://google.com') end)
-- vim.keymap.set('n', '<leader>rr', ':update | luafile %<cr>')
return M
