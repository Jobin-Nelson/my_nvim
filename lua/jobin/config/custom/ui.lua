local M = {}

local function bool2str(bool) return bool and "on" or "off" end

function M.set_indent()
  vim.ui.input({
    prompt = "Set indent value (>0 expandtab, <=0 noexpandtab): ",
  }, function(new_indent)
    new_indent = tonumber(new_indent)
    if new_indent == nil or new_indent == 0 then
      return
    end

    vim.bo.expandtab = (new_indent > 0)
    new_indent = math.abs(new_indent)
    vim.bo.tabstop = new_indent
    vim.bo.softtabstop = new_indent
    vim.bo.shiftwidth = new_indent
    vim.notify("Indent set to " .. new_indent)
  end)
end

function M.toggle_spell()
  vim.wo.spell = not vim.wo.spell
  vim.notify("Spell set to " .. bool2str(vim.wo.spell))
end

function M.toggle_diagnostics()
  if vim.diagnostic.is_enabled() then
    vim.diagnostic.enable(false)
    vim.notify('Diagnostics Disabled')
  else
    vim.diagnostic.enable()
    vim.notify('Diagnostics Enabled')
  end
end

function M.toggle_transparency()
  vim.opt.background = 'dark'
  local normal_hl = vim.api.nvim_get_hl(0, { name = 'Normal', link = false })

  ---@diagnostic disable-next-line: undefined-field
  if vim.tbl_isempty(normal_hl) or (normal_hl.bg == nil and normal_hl.ctermbg == nil) then
    vim.cmd.colorscheme(vim.g.colors_name or 'default')

    -- custom highlights
    local status_hl = vim.api.nvim_get_hl(0, { name = 'StatusLine', link = false })
    status_hl = vim.tbl_extend('force', status_hl, { bold = true })
    vim.api.nvim_set_hl(0, "StatusLine", status_hl)
    vim.api.nvim_set_hl(0, 'WinSeparator', { cterm = nil })
    return
  end

  normal_hl = vim.tbl_extend('force', normal_hl, { bg = 'None', ctermbg = 'None' })
  vim.api.nvim_set_hl(0, 'Normal', normal_hl)
  vim.api.nvim_set_hl(0, "StatusLine", { bold = true })
end

return M
