-- ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
-- ┃                          Types                           ┃
-- ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

---@class Jopts
---@field creds Creds?
---@field creds_file_path string
---@field should_reload_creds boolean

---@class Creds
---@field jira Jira

---@class Jira
---@field token string
---@field domain string

-- ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
-- ┃                   Core Implementation                    ┃
-- ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

---@class Jopts
local jopts = {
  creds = nil,
  creds_file_path = '~/playground/dev/creds.json',
}
setmetatable(jopts, {})

---@param force boolean?
function jopts:get_creds(force)
  if not self.creds or force then
    local normalized_creds_path = vim.fs.normalize(self.creds_file_path)
    ---@type Creds
    self.creds = vim.fn.json_decode(vim.fn.readfile(normalized_creds_path))
    vim.validate({
      jira = { self.creds.jira, 'table' },
      token = { self.creds.jira.token, 'string' },
      domain = { self.creds.jira.domain, 'string' },
    })
  end
end

---@param path string
function jopts:set_creds_file_path(path)
  self.creds_file_path = path
end

---@return string
function jopts:get_token()
  self:get_creds()
  return self.creds.jira.token
end

---@return string
function jopts:get_domain()
  self:get_creds()
  return self.creds.jira.domain
end

return jopts
