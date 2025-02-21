-- Major shoutout to
-- https://github.com/ibhagwan/nvim-lua/blob/main/lua/utils.lua


---@class FWinOpts
---@field width integer?
---@field height integer?
---@field buf integer

---@class JWin
---@field buf integer
---@field win integer

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
  vim.notify("All hidden buffers have been deleted", vim.log.levels.INFO, { title = 'Utils' })
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
      vim.api.nvim_buf_delete(original_bufnr, { force = true })
    end

    vim.notify(
      "Renamed to " .. new_filename,
      vim.log.levels.INFO,
      { title = 'Utils' }
    )
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

function M.leet()
  local cmd = { 'leet.py', '-n' }
  local response = vim.system(cmd, { text = true }):wait()
  if response.code ~= 0 or response.stdout == nil then
    vim.notify(
      'leet.py failed execution',
      vim.log.levels.ERROR,
      { title = 'Leetcode' }
    )
    return
  end
  local leet_file = string.match(response.stdout, "(%S+)%s*$")
  vim.cmd('tabedit ' .. leet_file)
end

---@param buf_to_delete number|nil
function M.better_bufdelete(buf_to_delete)
  local bufnr = buf_to_delete or vim.api.nvim_get_current_buf()
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

  vim.api.nvim_buf_delete(bufnr, { force = true })
end

--- Box header
---@param width integer? width of the box
function M.box(width)
  vim.ui.input({ prompt = "Box value: " }, function(value)
    if value == nil or vim.trim(value) == '' then
      return vim.notify(
        "No value provided",
        vim.log.levels.WARN,
        { title = 'Utils' }
      )
    end

    value = vim.trim(value)

    local top_component = {
      left = "┏",
      center = "━",
      right = "┓",
    }
    local middle_component = {
      left = "┃",
      center = " ",
      right = "┃",
    }
    local bottom_component = {
      left = "┗",
      center = "━",
      right = "┛",
    }

    local value_len = vim.fn.strchars(value)
    width = width or value_len + 4

    ---Constructs lines from left, center and right components
    ---@param comp table<string,string>
    ---@return string
    local function get_line(comp)
      return comp.left .. string.rep(comp.center, width - 2) .. comp.right
    end

    ---Helper for floor division
    ---@param n integer
    ---@return integer
    local function get_half(n)
      return math.floor(n / 2)
    end

    local lines = vim.tbl_map(get_line, { top_component, middle_component, bottom_component })

    local line_nr = vim.api.nvim_win_get_cursor(0)[1]
    vim.api.nvim_buf_set_lines(0, line_nr, line_nr, false, lines)

    local middle_line_nr = line_nr + 1

    local col_nr = get_half(width) - get_half(value_len) + (width % 2 == 0 and 1 or 2)

    vim.api.nvim_buf_set_text(0, middle_line_nr, col_nr, middle_line_nr, col_nr + value_len, { value })
  end)
end

---@param url string
---@param headers string[]?
---@param data string?
---@return table response
function M.request(url, headers, data)
  headers = vim.iter(headers)
      :map(function(header) return { '--header', header } end)
      :flatten()
      :totable()

  -- POST request data
  if data then
    vim.list_extend(headers, { '-X', 'POST', '-d', data })
  end

  local cmd = vim.iter({
    { 'curl', '-sSfL' }, -- flags
    headers,             -- headers + data?
    { url }              -- query url
  }):flatten():totable()

  return vim.system(cmd, { text = true }):wait()
end

---@param text string
---@return string[]
function M.shellsplit(text)
  local words = {}
  local spat, epat = [=[^(['"])]=], [=[(['"])$]=]
  local buf, quoted = nil, nil

  -- Iterate over each word in the input text
  for str in text:gmatch("%S+") do
    local squoted = str:match(spat)            -- Check if the word starts with a quote
    local equoted = str:match(epat)            -- Check if the word ends with a quote
    local escaped = str:match([=[(\*)['"]$]=]) -- Check if the quote is escaped

    if squoted and not quoted and not equoted then
      -- Start of a quoted string
      buf, quoted = str, squoted
    elseif buf and equoted == quoted and #escaped % 2 == 0 then
      -- End of a quoted string
      str, buf, quoted = buf .. ' ' .. str, nil, nil
    elseif buf then
      -- Middle of a quoted string
      buf = buf .. ' ' .. str
    end

    if not buf then
      -- Add the word to the result list, removing surrounding quotes
      table.insert(words, (str:gsub(spat, ""):gsub(epat, "")))
    end
  end

  return words
end

---@param line string
---@return string
---@return integer
function M.titleCaseLine(line)
  return line:gsub("(%a)([%w_']*)", function(first, rest)
    return first:upper() .. rest:lower()
  end)
end

function M.titleCase()
  -- if not in visual apply on current line
  -- if vim.api.nvim_get_mode()['mode']:lower() ~= 'v' then
  --   return vim.api.nvim_set_current_line(titleCaseLine(vim.api.nvim_get_current_line()))
  -- end

  local start_pos = vim.api.nvim_buf_get_mark(0, '<')
  local end_pos = vim.api.nvim_buf_get_mark(0, '>')
  -- when in visual line mode, end col will have very large value
  if end_pos[2] > 10000 then
    end_pos[2] = vim.fn.col("'>") - 2
  end

  local input = vim.api.nvim_buf_get_text(0, start_pos[1] - 1, start_pos[2], end_pos[1] - 1, end_pos[2] + 1, {})
  local output = vim.tbl_map(M.titleCaseLine, input)
  vim.api.nvim_buf_set_text(0, start_pos[1] - 1, start_pos[2], end_pos[1] - 1, end_pos[2] + 1, output)
end

---@param opts FWinOpts
---@return JWin
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

---@param buf integer
---@return JWin
function M.create_bottom_window(buf)
  buf = vim.api.nvim_buf_is_valid(buf)
      and buf or vim.api.nvim_create_buf(false, true)
  vim.cmd(('botright sb%s'):format(buf))
  local win = vim.api.nvim_get_current_win()

  local options = {
    win = {
      number = false,
      relativenumber = false,
      winfixheight = true,
    },
    buf = {
      buflisted = false,
    }
  }

  vim.schedule(function()
    for field, value in pairs(options.win) do
      vim.api.nvim_set_option_value(field, value, { scope = 'local', win = win })
    end

    for field, value in pairs(options.buf) do
      vim.api.nvim_set_option_value(field, value, { buf = buf })
    end
  end)

  return { buf = buf, win = win }
end

-- vim.keymap.set({ 'n', 'v' }, '<leader>rt', function() M.titleCase() end)
-- vim.keymap.set('n', '<leader>rr', ':update | luafile %<cr>')

return M
