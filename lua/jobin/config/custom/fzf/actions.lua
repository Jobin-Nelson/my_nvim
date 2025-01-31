local M = {}

---@param selected table
M.copy_entry = function(selected, _)
  vim.fn.setreg("+", selected[1])
  vim.notify(
    "Copied " .. selected[1],
    vim.log.levels.INFO,
    { title = 'FZF'}
  )
end

return M
