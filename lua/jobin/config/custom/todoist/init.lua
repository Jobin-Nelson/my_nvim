local utils = require('jobin.config.custom.utils')


-- ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
-- ┃                          Types                           ┃
-- ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

---@class Creds
---@field token string


---@class Project
---@field id integer
---@field name string

-- ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
-- ┃                   Core Implementation                    ┃
-- ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

local M = {}
local inbox_id = 2236837155

local task_fields = {
  'project_id',
  'section_id',
  'content',
  'description',
  'is_completed',
  'parent_id',
  'priority',
  'due',
  'duration',
}

---@return string
local function get_token()
  local creds_file_path = vim.fs.joinpath(
    os.getenv('XDG_DATA_HOME') or vim.fs.normalize('~/.local/share'),
    'todoist', 'creds.json')

  ---@type Creds
  local creds = vim.fn.json_decode(vim.fn.readfile(creds_file_path))
  if not creds then
    error('No jira.json file found')
  end
  local token = creds and creds.token
  if not token then
    error('Cannot parse jira.json file')
  end
  return token
end


---@param url string
---@param headers string[]?
---@param data string?
---@return string
function M.request(url, headers, data)
  local uuid_res = vim.system({ 'uuidgen' }, { text = true }):wait()
  local random = math.random(100000, 999999)
  local uuid = uuid_res.code == 0 and uuid_res.stdout
      or ('%d%s'):format(random, ('-' .. random):rep(4))

  local default_headers = {
    'Authorization: Bearer ' .. get_token(),
    'Content-Type: application/json',
    ('X-Request-Id: %s'):format(uuid)
  }
  headers = vim.iter(vim.list_extend(default_headers, headers or {}))
      :map(function(header) return { '--header', header } end)
      :flatten()
      :totable()

  local response = utils.request(url, headers, data)
  if response.code ~= 0 or response.stdout == '' then
    error('Todoist request failed')
  end

  return response.stdout
end

---@param project Project
---@return string
local function project2Line(project)
  return ('- [%s] %s'):format(project.id, project.name)
end

---@param msg string
---@param level? integer
function M.notify(msg, level)
  vim.notify(
    msg,
    level or vim.log.levels.ERROR,
    { title = 'Todoist' }
  )
end

---@return Project[]
function M.get_projects()
  local projects_file = vim.fs.joinpath(
    os.getenv('XDG_STATE_HOME') or vim.fs.normalize('~/.local/state'),
    'todoist', 'projects.json'
  )
  -- create project state if not present
  if not vim.uv.fs_stat(projects_file) then
    vim.fn.mkdir(vim.fn.fnamemodify(projects_file, ':p:h'), 'p')
    local file = io.open(projects_file, 'w+')
    if not file then
      M.notify(('Failed to open file %s'):format(projects_file))
      return {}
    end
    file:write(M.request('https://api.todoist.com/rest/v2/projects'))
    file:close()
  end
  return vim.fn.json_decode(vim.fn.readfile(projects_file))
end

-- $ curl "https://api.todoist.com/rest/v2/tasks" \
--     -X POST \
--     --data '{"content": "Buy Milk", "project_id": "2203306141"}' \
--     -H "Content-Type: application/json" \
--     -H "X-Request-Id: $(uuidgen)" \
--     -H "Authorization: Bearer 0123456789abcdef0123456789"
---@param content string
---@param project_id integer?
function M.add_task_to_project(content, project_id)
  local data = {
    content = content,
    project_id = project_id or inbox_id,
  }
  M.request('https://api.todoist.com/rest/v2/tasks', {}, vim.json.encode(data))
end

function M.add_task()
  local content = vim.fn.input({ prompt = 'Todo > ' })
  if content == '' then return end
  M.add_task_to_project(content)
end



-- vim.keymap.set('n', '<leader>rt', function() M.get_projects() end)
-- vim.keymap.set('n', '<leader>rr', ':update | luafile %<cr>')
return M
