local M = {}

local terminal_state = {
  buf = -1,
  win = -1,
}

---@param opts table?
---@return table<string,integer>
function M.create_floating_window(opts)
  opts = opts or {}
  local width = opts.width or math.floor(vim.o.columns * 0.8)
  local height = opts.height or math.floor(vim.o.lines * 0.8)

  local col = math.floor((vim.o.columns - width) / 2)
  local row = math.floor((vim.o.lines - height) / 2)

  local buf = vim.api.nvim_buf_is_valid(opts.buf)
      and opts.buf or vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    col = col,
    row = row,
    style = 'minimal',
    border = 'rounded',
  })

  return { buf = buf, win = win }
end

function M.toggle_term()
  if not vim.api.nvim_win_is_valid(terminal_state.win) then
    terminal_state = M.create_floating_window { buf = terminal_state.buf }
    if vim.bo[terminal_state.buf].buftype ~= 'terminal' then
      vim.cmd.term()
    end
  else
    vim.api.nvim_win_hide(terminal_state.win)
  end
end

return M
