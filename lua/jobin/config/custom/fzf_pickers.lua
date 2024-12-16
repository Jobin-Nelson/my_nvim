local fzf_lua = require 'fzf-lua'

local M = {}


---@param cmd string
---@param opts table?
M.fzf_cd_dir = function(cmd, opts)
  local default_opts = {
    fzf_opts = {
      ['--preview'] = "ls -lAhF --group-directories-first {}",
      ['--preview-window'] = 'hidden,down,50%',
    },
    prompt = "cd ❯ ",
    winopts = {
      title = " Change Directory ",
      title_pos = "center",
      height = 0.40,
      width = 0.40,
      row = 0.50,
      col = 0.50,
    },
    actions = {
      ['default'] = function(selected)
        vim.cmd("tcd " .. selected[1])
        vim.notify(
          "Changed directory into " .. selected[1],
          vim.log.levels.INFO,
          { title = 'FZF' }
        )
      end
    },
    fn_transform = function(x)
      return fzf_lua.utils.ansi_codes.magenta(x)
    end
  }
  opts = vim.tbl_deep_extend('force', default_opts, opts or {})
  fzf_lua.fzf_exec(cmd, opts)
end

---@param opts table?
M.fzf_read_file = function(opts)
  local path = require('fzf-lua.path')
  local default_opts = {
    prompt = "read ❯ ",
    cwd_prompt = false,
    winopts = {
      title = " Read File ",
      title_pos = "center",
      height = 0.50,
      width = 0.50,
      row = 0.50,
      col = 0.50,
      preview = {
        hidden = 'hidden',
      }
    },
    actions = {
      ['default'] = function(selected, lopts)
        for _, sel in ipairs(selected) do
          local entry = path.entry_to_file(sel, lopts, lopts._uri)
          local fullpath = entry.path
          vim.cmd('0read ' .. fullpath)
          vim.notify(
            'Inserted ' .. vim.fs.basename(fullpath),
            vim.log.levels.INFO,
            { title = 'FZF' }
          )
        end
      end
    }
  }
  opts = vim.tbl_deep_extend('force', default_opts, opts or {})
  fzf_lua.files(opts)
end

---@param opts table?
M.fzf_move_file = function(opts)
  local rename_file = require('jobin.config.custom.utils').rename_file
  local default_opts = {
    fzf_opts = {
      ['--preview'] = "ls -lAhF --group-directories-first {}",
      ['--preview-window'] = 'hidden,down,50%',
    },
    prompt = "move ❯ ",
    winopts = {
      title = " Move File ",
      title_pos = "center",
      height = 0.40,
      width = 0.40,
      row = 0.50,
      col = 0.50,
    },
    actions = {
      ['default'] = function(selected)
        rename_file(selected[1])
      end
    }
  }
  opts = vim.tbl_deep_extend('force', default_opts, opts or {})
  local cwd = require('jobin.config.custom.utils').get_git_root_buf() or vim.uv.cwd()
  local cmd = string.format(
    [[find %s \( -path '*/.git' -o -path '*/.obsidian' -o -path '*/node_modules' -o -path '*/.venv' \) -prune -o -type d -print]],
    cwd)
  fzf_lua.fzf_exec(cmd, opts)
end

M.fzf_second_brain = function()
  local second_brain = "~/playground/projects/second_brain"
  fzf_lua.files({
    cwd = second_brain,
    actions = {
      ['ctrl-space'] = function(_, opts)
        local query = opts.__call_opts.query
        if query == "" then
          return vim.notify(
            'Query is empty',
            vim.log.levels.INFO,
            { title = 'FZF' }
          )
        end
        local md_suffix = '.md'
        if query:sub(- #md_suffix) ~= md_suffix then
          query = query .. md_suffix
        end
        local new_file = vim.fs.joinpath(second_brain, query)
        vim.cmd.edit(new_file)
      end
    }
  })
end

-- vim.keymap.set('n', '<leader>rt', function() M.fzf_move_file() end)
-- vim.keymap.set('n', '<leader>rr', ':update | luafile %<cr>')

return M
