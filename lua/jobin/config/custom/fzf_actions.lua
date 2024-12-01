local M = {}

---@param selected table
M.copy_entry = function(selected, _)
  vim.fn.setreg("+", selected[1])
  print("Copied " .. selected[1])
end

return M
