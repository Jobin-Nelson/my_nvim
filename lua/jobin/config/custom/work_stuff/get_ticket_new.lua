-- https://docs.atlassian.com/software/jira/docs/api/REST/8.20.14/
--
local M = {}

local function get_token()
  local creds_file_path = vim.fs.normalize('~/playground/dev/illumina/creds/jira.json')
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

local function query_issue_details(token, issue_id)
  local cmd = 'curl'
  local flags = '-sSfL'
  local header = "Authorization: Bearer " .. token
  local api_get_issue = string.format(
    'https://jira.illumina.com/rest/api/2/issue/%s?fields=summary,description,subtasks',
    issue_id
  )

  local command = {
    cmd,
    flags,
    '--header', header,
    api_get_issue
  }

  local response = vim.fn.system(command)
  if vim.v.shell_error ~= 0 then
    error('Get issue request failed')
  end

  return response
end

local function append_subtasks(lines, subtasks)
  if not subtasks then
    vim.print('Issue %s does not have subtasks')
    return
  end
  table.insert(lines, '** Sub-Tasks')
  for _, subtask in ipairs(subtasks) do
    local subtask_summary = subtask.fields and subtask.fields.summary
    local subtask_id = subtask.key
    if not subtask_summary or not subtask_id then
      goto continue
    end
    table.insert(lines,
      string.format('*** TODO [%s] %s', subtask_id, subtask_summary)
    )
    ::continue::
  end
end

local function append_header(lines, fields, issue_id)
  table.insert(lines, '* ' .. fields.summary)
  table.insert(lines, string.format('*Ticket*: [[https://jira.illumina.com/browse/%s][%s]]', issue_id, issue_id))
  table.insert(lines, '** Description')

  for _, description_line in ipairs(vim.split(fields.description, '\r\n\r\n')) do
    table.insert(lines, description_line)
  end
end

local function populate_issue_details(issue_id)
  if issue_id == nil or issue_id == '' then
    error('Invalid issue_id entered')
  end

  local token = get_token()
  local response = vim.json.decode(query_issue_details(token, issue_id), { object = true, array = true})
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
  local issue_id = vim.fn.input({ prompt = 'Enter Issue ID: '})
  populate_issue_details(issue_id)
  -- vim.ui.input({
  --   prompt = 'Enter Issue ID: ',
  -- }, populate_issue_details)
end


-- vim.keymap.set('n', '<leader>rt', M.populate_issue)
-- vim.keymap.set('n', '<leader>rr', ':update | luafile %<cr>')
return M
