-- Get issue-id
-- Get link + cookie
-- Make request
-- Get description from json result
-- Convert html to org
-- Output the result to buffer

local function get_issue_id()
  return vim.fn.expand('<cword>')
end

-- example json file
-- {
--   "jira": {
--     "cookie": "...",
--     "link": "..."
--   }
-- }
local function get_link(issue_id)
  local creds_file_path = vim.fs.normalize('~/playground/dev/illumina/creds/jira.json')
  local creds = vim.fn.json_decode(vim.fn.readfile(creds_file_path))
  if not creds then
    error('No jira.json file found')
  end
  local link = creds.jira.link:gsub('(issueIdOrKey=)([^&]*)', string.format('%%1%s', issue_id))
  local cookie = 'Cookie: ' .. creds.jira.cookie
  if not link or not cookie then
    error('Cannot parse jira.json file')
  end
  return link, cookie
end

local function populate_summary(text)
  local issue_id = get_issue_id()
  local bufnr = vim.api.nvim_get_current_buf()
  local line_nr = vim.fn.line('.')
  local lines = {
    '* TODO ' .. text,
    '',
    '** Description',
    string.format('*Ticket*: [[https://jira.illumina.com/browse/%s][%s]]', issue_id, issue_id),
  }
  vim.api.nvim_buf_set_lines(bufnr, line_nr, line_nr, false, lines)
  return line_nr + #lines
end

local function populate_description(html, line_nr)
  local uv = vim.loop
  local handle
  local stdin, stdout = uv.new_pipe(), uv.new_pipe()
  local bufnr = vim.api.nvim_get_current_buf()

  if not stdin or not stdout then
    error('Cannot create new pipe')
  end

  local function on_exit(status)
    uv.read_stop(stdout)
    uv.close(handle)
    if status ~= 0 then
      print('pandoc exited with ' .. status)
    end
  end

  local cmd = 'pandoc'
  local cmd_args = { '-f', 'html', '-t', 'org', '-' }
  local options = {
    args = cmd_args,
    stdio = { stdin, stdout, nil }
  }

  handle = uv.spawn(cmd, options, on_exit)

  if not handle then
    error('Cannot spawn pandoc process')
  end

  uv.read_start(stdout, function(status, data)
    if data then
      vim.schedule(function()
        data = data:gsub('\n\n', '\n')
        vim.api.nvim_buf_set_lines(bufnr, line_nr, line_nr, false, vim.split(data:gsub('u00a0', ''), '\n'))
      end)
    end
  end)
  uv.write(stdin, html)
  uv.shutdown(stdin, function()
    uv.close(stdin)
  end)
end

local function get_description(_, data)
  if data and data[1] ~= '' then
    local response = vim.fn.json_decode(data)
    if not response then
      error('Cannot convert response to json')
    end
    local description_html = response.tabs.defaultTabs[3].sections[1].html
    local summary = response.tabs.defaultTabs[1].fields[1].text
    local line_nr = populate_summary(summary)
    populate_description(description_html, line_nr)
  end
end

local function populate_ticket_details(link, cookie)
  local cmd = 'curl'
  local command = {
    cmd,
    '-sSfL',
    '-H',
    cookie,
    link,
  }
  vim.fn.jobstart(command, {
    stdout_buffered = true,
    on_stdout = get_description,
  })
end

local M = {}

M.populate_ticket = function()
  local issue_id = get_issue_id()
  local link, cookie = get_link(issue_id)
  populate_ticket_details(link, cookie)
end
vim.keymap.set('n', '<leader>rt', M.populate_ticket)
vim.keymap.set('n', '<leader>rr', ':update | luafile %<cr>')

return M
