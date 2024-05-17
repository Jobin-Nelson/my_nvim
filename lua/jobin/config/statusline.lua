local modes = {
  ["n"] = "NORMAL",
  ["no"] = "NORMAL",
  ["v"] = "VISUAL",
  ["V"] = "VISUAL LINE",
  [""] = "VISUAL BLOCK",
  ["s"] = "SELECT",
  ["S"] = "SELECT LINE",
  [""] = "SELECT BLOCK",
  ["i"] = "INSERT",
  ["ic"] = "INSERT",
  ["R"] = "REPLACE",
  ["Rv"] = "VISUAL REPLACE",
  ["c"] = "COMMAND",
  ["cv"] = "VIM EX",
  ["ce"] = "EX",
  ["r"] = "PROMPT",
  ["rm"] = "MOAR",
  ["r?"] = "CONFIRM",
  ["!"] = "SHELL",
  ["t"] = "TERMINAL",
  ["nt"] = "TERMINAL",
}

local icons = require('jobin.config.icons')

---@return string
local function vcs()
  ---@diagnostic disable-next-line: undefined-field
  local git_info = vim.b.gitsigns_status_dict
  local git_branch = git_info and git_info.head and string.format(' %s %s ', icons.git.Branch, git_info.head)
  return git_branch or ''
end

---@return string
local function mode()
  local current_mode = vim.api.nvim_get_mode().mode
  return string.format(" %s ", modes[current_mode]:upper())
end

---@return string
local function fileicon()
  local ok, nvim_web_devicons = pcall(require, 'nvim-web-devicons')
  if not ok then
    return icons.kind.File
  end
  local icon = nvim_web_devicons.get_icon_by_filetype(vim.bo.filetype, {})
  return (icon and icon .. ' ') or icons.kind.File
end

---@return string
local function line_info()
  if vim.bo.filetype == 'alpha' then
    return ''
  end
  return '%10.(%l:%c%V%) %P '
end

---@return string
function Statusline()
  local filler = ' %= '
  local file_segment = '%(' .. fileicon() .. '%<%f %h%m%r%)'

  return table.concat({
    -- '%#Normal#',
    '%#StatusLine#',
    mode(),
    vcs(),
    '%#Normal#',
    filler,
    file_segment,
    filler,
    '%#Normal#',
    '%#StatusLine#',
    line_info(),
  })
end

-- vim.opt.statusline= "%<%=%(%f %h%m%r%)%=%-14.(%l,%c%V%) %P"
vim.opt.statusline = '%!v:lua.Statusline()'
