-- Thanks folke
-- Stolen straight from https://github.com/folke/snacks.nvim/blob/main/lua/snacks/gitbrowse.lua

---@class Git.Opts
---@field url_patterns? table<string, table<string, string|fun(fields:Git.Fields):string>>

---@class Git.Fields
---@field branch? string
---@field file? string
---@field line_start? number
---@field line_end? number
---@field commit? string
---@field line_count? number

---@class Git.Remote
---@field name string
---@field url string

local M = {}

M.opts = {
  ---@type "repo" | "branch" | "file" | "commit"
  what = "file", -- what to open. not all remotes support all types
  branch = nil, ---@type string?
  line_start = nil, ---@type number?
  line_end = nil, ---@type number?
  -- patterns to transform remotes to an actual URL
  -- stylua: ignore
  remote_patterns = {
    { "^(https?://.*)%.git$",               "%1" },
    { "^git@(.+):(.+)%.git$",               "https://%1/%2" },
    { "^git@(.+):(.+)$",                    "https://%1/%2" },
    { "^git@(.+)/(.+)$",                    "https://%1/%2" },
    { "^ssh://git@(.*)$",                   "https://%1" },
    { "^ssh://([^:/]+)(:%d+)/(.*)$",        "https://%1/%3" },
    { "^ssh://([^/]+)/(.*)$",               "https://%1/%2" },
    { "ssh%.dev%.azure%.com/v3/(.*)/(.*)$", "dev.azure.com/%1/_git/%2" },
    { "^https://%w*@(.*)",                  "https://%1" },
    { "^git@(.*)",                          "https://%1" },
    { ":%d+",                               "" },
    { "%.git$",                             "" },
  },
  url_patterns = {
    ["github%.com"] = {
      branch = "/tree/{branch}",
      file = "/blob/{branch}/{file}#L{line_start}-L{line_end}",
      commit = "/commit/{commit}",
    },
    ["gitlab%.com"] = {
      branch = "/-/tree/{branch}",
      file = "/-/blob/{branch}/{file}#L{line_start}-L{line_end}",
      commit = "/-/commit/{commit}",
    },
    ["bitbucket%.org"] = {
      branch = "/src/{branch}",
      file = "/src/{branch}/{file}#lines-{line_start}-L{line_end}",
      commit = "/commits/{commit}",
    },
  },
}

---@param cwd? string
---@return string|nil
local function get_git_root(cwd)
  local git_root = vim.fs.find('.git', { path = cwd, upward = true })[1]
  return git_root and vim.fn.fnamemodify(git_root, ':h') or nil
end

---@return string|nil
function M.get_git_root_buf()
  local parent = vim.fs.dirname(vim.api.nvim_buf_get_name(0))
  return get_git_root(parent)
end

function M.cd_git_root()
  local git_root = M.get_git_root_buf()
  if not git_root then
    vim.notify(
      'Not a git repo: ' .. vim.fn.expand('%:p:h'),
      vim.log.levels.WARN,
      { title = 'Git' }
    )
    return
  end
  if git_root == vim.uv.cwd() then
    vim.notify('Already at git root: ' .. git_root, vim.log.levels.INFO, { title = 'Git' })
    return
  end
  if vim.uv.fs_stat(git_root) then
    vim.cmd('lcd ' .. git_root)
    vim.notify('Directory changed to ' .. git_root, vim.log.levels.INFO, { title = 'Git' })
  else
    error(git_root .. ' not accessible')
  end
end

---@param remote string
---@param opts? Git.Opts
---@return string
local function get_repo(remote, opts)
  opts = vim.tbl_deep_extend('force', M.opts, opts)
  local ret = remote
  for _, pattern in ipairs(opts.remote_patterns) do
    ret = ret:gsub(pattern[1], pattern[2]) --[[@as string]]
  end
  return ret:find("https://") == 1 and ret or ("https://%s"):format(ret)
end

---@param repo string
---@param fields Git.Fields
---@param opts? Git.Opts
---@return string
local function get_url(repo, fields, opts)
  opts = vim.tbl_deep_extend('force', M.opts, opts)
  for remote, patterns in pairs(opts.url_patterns) do
    if repo:find(remote) then
      local pattern = patterns[opts.what]
      if type(pattern) == "string" then
        return repo .. pattern:gsub("(%b{})", function(key)
          return fields[key:sub(2, -2)] or key
        end)
      elseif type(pattern) == "function" then
        return repo .. pattern(fields)
      end
    end
  end
  return repo
end

---@param cmd string[]
---@param err string
local function system(cmd, err)
  local res = vim.system(cmd):wait()
  if res.code ~= 0 then
    vim.notify(err, vim.log.levels.ERROR, { title = 'Git' })
    error(('command failed: %s'):format(cmd))
  end
  return vim.split(vim.trim(res.stdout), '\n')
end

---@param hash string
---@param cwd string
---@return boolean
local function is_valid_commit_hash(hash, cwd)
  if not (hash:match("^[a-fA-F0-9]+$") and #hash >= 7) then
    return false
  end
  system({ "git", "-C", cwd, "rev-parse", "--verify", hash }, "Invalid commit hash")
  return true
end

---@return Git.Remote
local function get_remotes()
  local opts = vim.deepcopy(M.opts)
  local file = vim.api.nvim_buf_get_name(0) ---@type string?
  file = file and (vim.uv.fs_stat(file) or {}).type == "file" and vim.fs.normalize(file) or nil
  local cwd = file and vim.fn.fnamemodify(file, ":h") or vim.fn.getcwd()
  local word = vim.fn.expand("<cword>")
  local is_commit = is_valid_commit_hash(word, cwd)
  local fields = {
    branch = opts.branch
        or system({ "git", "-C", cwd, "rev-parse", "--abbrev-ref", "HEAD" }, "Failed to get current branch")[1],
    file = file and system({ "git", "-C", cwd, "ls-files", "--full-name", file }, "Failed to get git file path")[1],
    line_start = opts.line_start,
    line_end = opts.line_end,
    commit = is_commit and word or nil,
  }

  -- Get visual selection range if in visual mode
  if vim.fn.mode():find("[vV]") then
    vim.fn.feedkeys(":", "nx")
    local line_start = vim.api.nvim_buf_get_mark(0, "<")[1]
    local line_end = vim.api.nvim_buf_get_mark(0, ">")[1]
    vim.fn.feedkeys("gv", "nx")
    -- Ensure line_start is always the smaller number
    if line_start > line_end then
      line_start, line_end = line_end, line_start
    end
    fields.line_start = line_start
    fields.line_end = line_end
  else
    fields.line_start = fields.line_start or vim.fn.line(".")
    fields.line_end = fields.line_end or fields.line_start
  end
  fields.line_count = fields.line_end - fields.line_start + 1

  opts.what = is_commit and "commit" or opts.what == "commit" and not fields.commit and "file" or opts.what
  opts.what = not is_commit and opts.what == "file" and not fields.file and "branch" or opts.what
  opts.what = not is_commit and opts.what == "branch" and not fields.branch and "repo" or opts.what

  local remotes = {} ---@type Git.Remote[]

  for _, line in ipairs(system({ "git", "-C", cwd, "remote", "-v" }, "Failed to get git remotes")) do
    local name, remote = line:match("(%S+)%s+(%S+)%s+%(fetch%)")
    if name and remote then
      local repo = get_repo(remote, opts)
      if repo then
        table.insert(remotes, {
          name = name,
          url = get_url(repo, fields, opts),
        })
      end
    end
  end
  return remotes
end

---@param action fun(string): nil
---@param message string
local function perform_action(action, message)
  local remotes = get_remotes()
  local function open(remote)
    if remote then
      vim.notify(("%s [%s](%s)"):format(message, remote.name, remote.url),
        vim.log.levels.INFO,
        { title = "Git" })
      action(remote.url)
    end
  end

  if #remotes == 0 then
    return vim.notify("No git remotes found", vim.log.levels.ERROR, { title = "Git" })
  elseif #remotes == 1 then
    return open(remotes[1])
  end

  vim.ui.select(remotes, {
    prompt = "Select remote to browse",
    format_item = function(item)
      return item.name .. (" "):rep(8 - #item.name) .. " 🔗 " .. item.url
    end,
  }, open)
end

function M.open()
  perform_action(vim.ui.open, 'Opening')
end

function M.copy()
  perform_action(function(url)
    vim.fn.setreg("+", url)
  end, 'Copied')
end

-- vim.keymap.set({ 'n', 'v' }, '<leader>rt', function() M.open() end)
-- vim.keymap.set('n', '<leader>rr', ':update | luafile %<cr>')

return M
