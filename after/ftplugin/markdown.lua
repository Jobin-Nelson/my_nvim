-- Options
vim.opt_local.wrap = true

-- keymaps
local function toggle_checkbox()
  local line = vim.api.nvim_get_current_line()
  local new_line
  if line:match('^%s*%- %[ %]') then
    new_line = line:gsub('%[ %]', '[X]', 1)
  elseif line:match('^%s*%- %[X%]') then
    new_line = line:gsub('%[X%]', '[ ]', 1)
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
