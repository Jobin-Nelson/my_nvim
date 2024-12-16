---@param mode "visual" | "normal"
local send_lines_to_terminal = function(mode)
  local modes = {
    visual = { 'v', '.' },
    normal = { '.', '.' },
  }
  local start_char, end_char = unpack(modes[mode])
  local lines = vim.api.nvim_buf_get_lines(
    0,
    vim.fn.line(start_char) - 1,
    vim.fn.line(end_char),
    false
  )
  local terminal = Snacks.terminal.get()
  local term_bufnr = terminal and terminal.buf
  local enter = '\n'
  assert(term_bufnr, 'ERROR: No terminal bufnr')
  -- toggle terminal if not visible
  if not vim.iter(vim.fn.tabpagebuflist()):find(
        function(b) return b == term_bufnr end
      ) then
    Snacks.terminal()
  end
  -- strip trailing whitespaces
  while #lines > 0 and vim.trim(lines[#lines]) == "" do
    lines[#lines] = nil
  end
  -- send commands to terminal
  vim.api.nvim_chan_send(
    vim.bo[term_bufnr].channel,
    table.concat(lines, enter) .. enter
  )
  -- scroll to bottom
  vim.api.nvim_buf_call(term_bufnr, function()
    local info = vim.api.nvim_get_mode()
    if info and (info.mode == 'n' or info.mode == 'nt') then
      vim.cmd('normal! G')
    end
  end)
end

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@module 'snacks'
  ---@type snacks.Config
  opts = {
    bigfile = { enabled = true },
    input = { enabled = true },
    notifier = {
      enabled = true,
      timeout = 3000,
    },
    quickfile = { enabled = true },
    dashboard = { enabled = false },
    scroll = { enabled = false },
    indent = { enabled = false },
    statuscolumn = { enabled = false },
    words = { enabled = false },
    styles = {
      notification = {
        -- wo = { wrap = true } -- Wrap notifications
      }
    }
  },
  keys = {
    { "<leader>z",  function() Snacks.zen() end,                     desc = "Toggle Zen Mode" },
    { "<C-w>m",     function() Snacks.zen.zoom() end,                desc = "Toggle Zoom" },
    { "<leader>n",  function() Snacks.notifier.show_history() end,   desc = "Notification History" },
    { "<leader>bd", function() Snacks.bufdelete() end,               desc = "Delete Buffer" },
    { "<leader>cR", function() Snacks.rename.rename_file() end,      desc = "Rename File" },
    { "<leader>gB", function() Snacks.gitbrowse() end,               desc = "Git Browse" },
    { "<leader>un", function() Snacks.notifier.hide() end,           desc = "Dismiss All Notifications" },
    { "<c-/>",      function() Snacks.terminal() end,                desc = "Toggle Terminal" },
    { "<c-_>",      function() Snacks.terminal() end,                desc = "which_key_ignore",         mode = { 'n', 't' } },
    { "<A-s>",      function() send_lines_to_terminal('normal') end, desc = "Send lines to terminal",   mode = { 'n' } },
    { "<A-s>",      function() send_lines_to_terminal('visual') end, desc = "Send lines to terminal",   mode = { 'v' } },
  },
  init = function()
    vim.api.nvim_create_autocmd("User", {
      group = vim.api.nvim_create_augroup('SnacksToggleCommands', { clear = true }),
      pattern = "VeryLazy",
      callback = function()
        -- Create some toggle mappings
        Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
        Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
        Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
        Snacks.toggle.diagnostics():map("<leader>ud")
        Snacks.toggle.line_number():map("<leader>ul")
        Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map(
          "<leader>uc")
        Snacks.toggle.treesitter():map("<leader>uT")
        Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
        Snacks.toggle.inlay_hints():map("<leader>uh")
        Snacks.toggle.indent():map("<leader>ug")
        Snacks.toggle.dim():map("<leader>uD")
      end,
    })
  end,
}
