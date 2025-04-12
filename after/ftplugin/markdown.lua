-- Options
vim.opt_local.wrap = true
vim.opt.foldtext = "v:lua.CustomFoldText()"

-- keymaps
local function toggle_checkbox()
  local line = vim.api.nvim_get_current_line()
  local new_line
  if line:match('^%s*%- %[ %]') then
    new_line = line:gsub('%[ %]', '[x]', 1)
  elseif line:match('^%s*%- %[[xX]%]') then
    new_line = line:gsub('%[[xX]%]', '[ ]', 1)
  else
    return vim.notify(
      'Current line not a checkbox',
      vim.log.levels.WARN,
      { title = 'Markdown' }
    )
  end
  vim.api.nvim_set_current_line(new_line)
end

vim.keymap.set('n', '<C-Space>', toggle_checkbox, { desc = 'Toggle Checkbox', buffer = 0 })
