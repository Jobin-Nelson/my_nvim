-- Note that: \19 = ^S and \22 = ^V.
local modes = {
  ['n'] = 'NORMAL',
  ['no'] = 'OP-PENDING',
  ['nov'] = 'OP-PENDING',
  ['noV'] = 'OP-PENDING',
  ['no\22'] = 'OP-PENDING',
  ['niI'] = 'NORMAL',
  ['niR'] = 'NORMAL',
  ['niV'] = 'NORMAL',
  ['nt'] = 'NORMAL',
  ['ntT'] = 'NORMAL',
  ['v'] = 'VISUAL',
  ['vs'] = 'VISUAL',
  ['V'] = 'VISUAL LINE',
  ['Vs'] = 'VISUAL',
  ['\22'] = 'VISUAL BLOCK',
  ['\22s'] = 'VISUAL',
  ['s'] = 'SELECT',
  ['S'] = 'SELECT LINE',
  ['\19'] = 'SELECT BLOCK',
  ['i'] = 'INSERT',
  ['ic'] = 'INSERT',
  ['ix'] = 'INSERT',
  ['R'] = 'REPLACE',
  ['Rc'] = 'REPLACE',
  ['Rx'] = 'REPLACE',
  ['Rv'] = 'VIRT REPLACE',
  ['Rvc'] = 'VIRT REPLACE',
  ['Rvx'] = 'VIRT REPLACE',
  ['c'] = 'COMMAND',
  ['cv'] = 'VIM EX',
  ['ce'] = 'EX',
  ['r'] = 'PROMPT',
  ['rm'] = 'MORE',
  ['r?'] = 'CONFIRM',
  ['!'] = 'SHELL',
  ['t'] = 'TERMINAL',
}

local icons = require('jobin.config.icons')

---@return string
local function vcs_component()
  ---@diagnostic disable-next-line: undefined-field
  local head = vim.b.gitsigns_head
  return head and string.format('%%#StatuslineGitBranch#%s %s ', icons.git.Branch, head) or ''
end

---@return string
local function diff()
  ---@diagnostic disable-next-line: undefined-field
  local diff_info = vim.b.gitsigns_status_dict
  if not diff_info then return '' end
  return table.concat({
    diff_info.added ~= 0 and ("%%#%s#%s%s"):format('GitSignsAdd', icons.git.LineAdded, diff_info.added) or '',
    diff_info.changed ~= 0 and ("%%#%s#%s%s"):format('GitSignsChange', icons.git.LineModified, diff_info.changed) or '',
    diff_info.removed ~= 0 and ("%%#%s#%s%s"):format('GitSignsDelete', icons.git.LineRemoved, diff_info.removed) or '',
  }, ' ')
end

---@return string
local function mode_component()
  local mode = modes[vim.api.nvim_get_mode().mode] or 'UNKOWN'
  -- Set the highlight group.
  local hl = 'Other'
  if mode:find 'NORMAL' then
    hl = 'Normal'
  elseif mode:find 'PENDING' then
    hl = 'Pending'
  elseif mode:find 'VISUAL' then
    hl = 'Visual'
  elseif mode:find 'INSERT' or mode:find 'SELECT' then
    hl = 'Insert'
  elseif mode:find 'COMMAND' or mode:find 'TERMINAL' or mode:find 'EX' then
    hl = 'Command'
  end
  return string.format("%%#StatuslineMode%s# %s ", hl, mode)
end

---@return string
local function file_component()
  local filetype = vim.bo.filetype
  if filetype == '' then
    filetype = '[No Name]'
  end
  local buf_name = vim.api.nvim_buf_get_name(0)
  local filename, ext = vim.fn.fnamemodify(buf_name, ':t'), vim.fn.fnamemodify(buf_name, ':e')

  local ok, nvim_web_devicons = pcall(require, 'nvim-web-devicons')
  local icon, icon_hl
  if not ok then
    icon = icons.kind.File
  else
    icon, icon_hl = nvim_web_devicons.get_icon(filename, ext)
    if not icon then
      icon, icon_hl = nvim_web_devicons.get_icon_by_filetype(filetype, { default = true })
    end
  end
  local is_modified = vim.api.nvim_get_option_value('modified', { buf = 0 }) and icons.ui.FileModified or ''
  local is_readonly = vim.api.nvim_get_option_value('readonly', { buf = 0 }) and icons.ui.FileReadOnly or ''
  return string.format('%%#%s#%s %%#StatuslineFilename#%s %s%s',
    icon_hl, icon, filename, is_modified, is_readonly)
end

local last_diagnostic_component = ''
---@return string
local function diagnostics()
  if vim.bo.filetype == 'lazy' then
    return ''
  end
  -- Use the last computed value if in insert mode.
  if vim.startswith(vim.api.nvim_get_mode().mode, 'i') then
    return last_diagnostic_component
  end

  local counts = vim.diagnostic.count(0, {
    severity = {
      vim.diagnostic.severity.ERROR,
      vim.diagnostic.severity.WARN,
      vim.diagnostic.severity.INFO,
      vim.diagnostic.severity.HINT,
    }
  })

  local highlights = {
    ERROR = 'DiagnosticError',
    WARN = 'DiagnosticWarn',
    INFO = 'DiagnosticInfo',
    HINT = 'DiagnosticHint',
  }

  local diagnostic_counts = {
    ERROR = counts[vim.diagnostic.severity.ERROR] or 0,
    WARN = counts[vim.diagnostic.severity.WARN] or 0,
    INFO = counts[vim.diagnostic.severity.INFO] or 0,
    HINT = counts[vim.diagnostic.severity.HINT] or 0,
  }

  local parts = {}
  for severity, count in pairs(diagnostic_counts) do
    if count > 0 then
      table.insert(parts, string.format('%%#%s#%s %d',
        highlights[severity],
        icons.diagnostics[severity], count))
    end
  end

  last_diagnostic_component = table.concat(parts, ' ')
  return last_diagnostic_component
end

local M = {}

---@return string
function M.status()
  -- if vim.bo.filetype == 'alpha' then
  --   return ''
  -- end

  local filler = ' %= '
  -- local file_segment = '%(' .. fileicon() .. '%<%f %h%m%r%)'
  local line_info = '%#StatuslineProgress# '
      .. icons.ui.Location .. ' %3.(%l:%v%) '
      .. icons.ui.ProgressDown .. ' %P '

  return table.concat({
    mode_component(),
    vcs_component(),
    diff(),
    filler,
    file_component(),
    filler,
    diagnostics(),
    line_info,
  }, ' ')
end

-- vim.opt.statusline= "%<%=%(%f %h%m%r%)%=%-14.(%l,%c%V%) %P"
vim.opt.statusline = "%!v:lua.require'jobin.config.statusline'.status()"

return M
