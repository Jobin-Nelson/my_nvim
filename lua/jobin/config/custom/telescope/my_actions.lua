local action_state = require "telescope.actions.state"

local M = {}

function M.copy_entry(_)
  local selection = vim.fn.fnamemodify(action_state.get_selected_entry().value, ":.")
  vim.fn.setreg("+", selection)
  vim.notify(
    "Copied " .. selection,
    vim.log.levels.INFO,
    { title = 'Telescope' }
  )
end

return M
