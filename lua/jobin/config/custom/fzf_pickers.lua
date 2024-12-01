local fzf_lua = require('fzf-lua')

local M = {}

---@param cmd string
---@param opts table?
M.fzf_cd_dir = function(cmd, opts)
  opts = opts or {}
  opts.prompt = "cd ❯ "
  opts.fn_transform = function(x)
    return fzf_lua.utils.ansi_codes.magenta(x)
  end
  opts.actions = {
    ['default'] = function(selected)
      vim.cmd("tcd " .. selected[1])
      vim.notify("Changed directory into " .. selected[1], vim.log.levels.INFO)
    end
  }
  fzf_lua.fzf_exec(cmd, opts)
end

---@param cmd string
---@param opts table?
M.fzf_read_file = function(cmd, opts)
  opts = opts or {}
  opts.prompt = "read ❯ "
  opts.actions = {
    ['default'] = function(selected)
      vim.cmd('0read ' .. selected[1])
      print('Inserted ' .. vim.fs.basename(selected[1]))
    end
  }
  fzf_lua.fzf_exec(cmd, opts)
end

---@param opts table?
M.fzf_move_file = function(opts)
  opts = opts or {}
  opts.prompt = "move ❯ "

  local cwd = require('jobin.config.custom.utils').get_git_root_buf() or vim.uv.cwd()
  local cmd = string.format([[find %s \( -path '*/.git' -o -path '*/.obsidian' -o -path '*/node_modules' -o -path '*/.venv' \) -prune -o -type d -print]], cwd)
  local rename_file = require('jobin.config.custom.utils').rename_file

  opts.actions = {
    ['default'] = function(selected)
      rename_file(selected[1])
    end
  }
  fzf_lua.fzf_exec(cmd, opts)
end

-- vim.keymap.set('n', '<leader>rt', function() M.fzf_move_file() end)
-- vim.keymap.set('n', '<leader>rr', ':update | luafile %<cr>')

return M
