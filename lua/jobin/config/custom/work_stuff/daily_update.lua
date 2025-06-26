---@param current_update string
---@return boolean
local function has_previous_update(current_update)
  local previous_file, number_of_files = nil, 0
  for file in vim.fs.dir(vim.fs.dirname(current_update)) do
    if number_of_files == 2 then
      break
    end
    previous_file = file
    number_of_files = number_of_files + 1
  end
  local current_file = os.date("%Y-%m-%d") .. ".md"
  local not_current_file = previous_file and previous_file ~= current_file
  return number_of_files == 2 or not_current_file
end

---@param current_update string
---@return string|nil
local function get_previous_update(current_update)
  if not has_previous_update(current_update) then
    return
  end
  local parent_dir = vim.fs.dirname(current_update)
  local current_date_string = vim.fn.fnamemodify(current_update, ":t:r")
  local one_day_in_sec = 24 * 60 * 60
  local current_time = vim.tbl_map(tonumber, {
    current_date_string:match("(%d+)-(%d+)-(%d+)"),
  })
  local previous_date = os.time({
    year = current_time[1],
    month = current_time[2],
    day = current_time[3],
  })

  local previous_update = nil
  for _ = 1, 10 do
    previous_date = previous_date - one_day_in_sec
    local previous_date_string = os.date("%Y-%m-%d", previous_date)
    previous_update = string.format("%s/%s.md", parent_dir, previous_date_string)
    if vim.uv.fs_stat(previous_update) then
      break
    end
  end
  return previous_update
end

---@param current_update string
---@param previous_update string|nil
local function setup_email(current_update, previous_update)
  if previous_update then
    vim.cmd(string.format("tabedit %s | vsplit %s", previous_update, current_update))
  else
    vim.cmd("tabedit " .. current_update)
    vim.notify(
      "No previous update found since 10 days ago",
      vim.log.levels.INFO,
      { title = 'Email Update' }
    )
  end
end

---@param _ any
---@param data string[]
local function capture_email(_, data)
  local current_update = vim.fs.normalize(data[1])
  local previous_update = get_previous_update(current_update)
  setup_email(current_update, previous_update)
end

local M = {
  opts = {
    daily_update_dir = '$HOME/playground/dev/daily_updates',
  }
}

M.open = function()
  local command = 'echo '
      .. M.opts.daily_update_dir .. '/$(date -d '
      .. '"$([[ $(date -d "+2 hours" +%u) -gt 5 ]] '
      .. '&& echo "next Monday" || echo "+2 hours")" +%Y-%m-%d).md'
  vim.fn.jobstart(command, {
    stdout_buffered = true,
    on_stdout = capture_email,
  })
end

-- vim.keymap.set("n", "<leader>rt", M.open)
-- vim.keymap.set("n", "<leader>rr", ":update | luafile %<cr>")

return M
