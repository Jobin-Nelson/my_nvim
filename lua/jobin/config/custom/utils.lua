-- Major shoutout to
-- https://github.com/ibhagwan/nvim-lua/blob/main/lua/utils.lua

local M = {}

local function is_valid_buf(buf)
  -- return vim.api.nvim_buf_is_loaded(buf)
  return vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted
end

M.delete_hidden_buffers = function()
  local all_bufs = vim.tbl_filter(is_valid_buf, vim.api.nvim_list_bufs())
  local all_wins = vim.api.nvim_list_wins()
  local visible_bufs = {}
  for _, win in ipairs(all_wins) do
    visible_bufs[vim.api.nvim_win_get_buf(win)] = true
  end

  for _, buf in ipairs(all_bufs) do
    if visible_bufs[buf] == nil then
      vim.api.nvim_buf_delete(buf, {})
    end
  end
  vim.notify("All hidden buffers have been deleted")
end

M.scratch_buffer = function()
  if vim.g.scratch_nr then
    local buf_nr = vim.g.scratch_nr
    for _, win_id in ipairs(vim.fn.win_findbuf(buf_nr)) do
      if vim.api.nvim_win_is_valid(win_id) then
        vim.api.nvim_set_current_win(win_id)
        return
      end
    end
    vim.cmd("vert sbuffer " .. buf_nr)
    return
  end

  local buf_nr = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_name(buf_nr, "scratch")
  vim.g.scratch_nr = buf_nr
  vim.cmd.vnew()
  vim.api.nvim_win_set_buf(0, buf_nr)
end

---@param target_dir string | nil
M.rename_file = function(target_dir)
  local original_filename = vim.api.nvim_buf_get_name(0)
  local original_bufnr = vim.api.nvim_get_current_buf()

  local function move_file(new_filename)
    if new_filename == "" or new_filename == nil then
      return
    end

    os.rename(original_filename, new_filename)
    vim.cmd('keepalt edit ' .. new_filename)
    local new_bufnr = vim.api.nvim_get_current_buf()

    for _, win_id in ipairs(vim.fn.win_findbuf(original_bufnr)) do
      vim.api.nvim_win_set_buf(win_id, new_bufnr)
    end
    if vim.fn.bufexists(original_bufnr) then
      vim.api.nvim_buf_delete(original_bufnr, {})
    end

    vim.notify("Renamed to " .. new_filename)
  end

  if target_dir then
    if vim.fn.isdirectory(target_dir) == 1 then
      target_dir = vim.fs.joinpath(target_dir, vim.fs.basename(original_filename))
    end
    move_file(target_dir)
  else
    vim.ui.input({
      prompt = "Rename: ",
      default = original_filename,
      completion = "file",
    }, move_file)
  end
end

M.start_journal = function()
  local second_brain = vim.fs.normalize("~/playground/projects/second_brain")
  local journal_dir = second_brain .. '/Resources/journal'
  local template_file = second_brain .. '/Resources/Templates/daily_note_template.md'

  local journal_path = string.format("%s/%s.md", journal_dir, os.date("%Y-%m-%d"))

  vim.cmd("tabedit " .. journal_path)
  local filesize = vim.fn.getfsize(journal_path)
  if filesize < 1 and filesize ~= -2 then
    vim.cmd('0read ' .. template_file)
  end
  vim.cmd('lcd ' .. second_brain)
  vim.opt_local.wrap = true
  vim.opt_local.linebreak = true
end

---@param cwd? string
---@return string|nil
local function get_git_root(cwd)
  local cmd = { 'git', 'rev-parse', '--show-toplevel' }
  if cwd then
    table.insert(cmd, 2, '-C')
    table.insert(cmd, 3, cwd)
  end
  local output = vim.fn.systemlist(cmd)
  if vim.v.shell_error ~= 0 then
    return nil
  end
  return output[1]
end

---@return string|nil
function M.get_git_root_buf()
  local parent = vim.fs.dirname(vim.api.nvim_buf_get_name(0))
  return get_git_root(parent)
end

function M.cd_git_root()
  local git_root = M.get_git_root_buf()
  if not git_root then
    print('Not a git repo: ' .. vim.fn.expand('%:p:h'))
    return
  end
  if git_root == vim.loop.cwd() then
    vim.notify('Already at git root: ' .. git_root)
    return
  end
  if vim.loop.fs_stat(git_root) then
    vim.cmd('lcd ' .. git_root)
    vim.notify('Directory changed to ' .. git_root)
  else
    error(git_root .. ' not accessible')
  end
end

function M.leet()
  if vim.fn.executable('leet.py') ~= 1 then
    print('leet.py not found')
    return
  end

  local cmd = { 'leet.py', '-n' }
  local output = vim.fn.system(cmd)
  if vim.v.shell_error ~= 0 then
    print('leet.py failed execution')
    return
  end
  local leet_file = string.match(output, "(%S+)%s*$")
  vim.cmd('tabedit ' .. leet_file)
end

function M.term_toggle()
  local term_bufnr = vim.g.custom_terminal_bufnr

  -- no prev terminal
  if term_bufnr == nil or not is_valid_buf(term_bufnr) then
    vim.cmd('botright new | term')
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    local custom_terminal_bufnr = vim.api.nvim_get_current_buf()
    vim.g.custom_terminal_bufnr = custom_terminal_bufnr
    -- to enter insert mode when switching buffers
    vim.api.nvim_create_autocmd("BufEnter", {
      buffer = custom_terminal_bufnr,
      callback = function()
        vim.cmd.startinsert()
      end,
    })
    return
  end

  -- use prev terminal
  term_bufnr = vim.g.custom_terminal_bufnr
  for _, win_id in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.api.nvim_win_get_buf(win_id) == term_bufnr then
      -- return vim.api.nvim_set_current_win(win_id)
      return vim.api.nvim_win_close(win_id, false)
    end
  end
  vim.cmd('botright sb' .. term_bufnr)
end

function M.better_bufdelete()
  local bufnr = vim.api.nvim_get_current_buf()
  local next_bufnr = nil

  for _, nr in ipairs(vim.api.nvim_list_bufs()) do
    if is_valid_buf(nr) and nr ~= bufnr then
      next_bufnr = nr
      break
    end
  end

  next_bufnr = next_bufnr or vim.api.nvim_create_buf(true, false)

  for _, win_id in ipairs(vim.fn.win_findbuf(bufnr)) do
    vim.api.nvim_win_set_buf(win_id, next_bufnr)
  end

  vim.api.nvim_buf_delete(bufnr, {})
end

-- vim.keymap.set('n', '<leader>rt', M.better_bufdelete)
-- vim.keymap.set('n', '<leader>rr', ':update | luafile %<cr>')

return M
