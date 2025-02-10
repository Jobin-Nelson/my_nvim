local M = {}

function M.dot_files()
  local find_dot_files = function(opts, ctx)
    ---@diagnostic disable-next-line: missing-fields
    return require("snacks.picker.source.proc").proc({
      opts,
      {
        cmd = "git",
        args = {
          "--git-dir",
          vim.fs.joinpath(vim.env.HOME, ".dotfiles"),
          "--work-tree",
          vim.env.HOME,
          "ls-tree",
          "--name-only",
          "--full-tree",
          "-r",
          "HEAD",
        },
        transform = function(item)
          item.file = item.text
        end
      },
    }, ctx)
  end

  ---@diagnostic disable-next-line: missing-fields
  Snacks.picker.pick({
    source = 'dotfiles',
    title = 'Dot Files',
    finder = find_dot_files,
  })
end

function M.move_file()
  local from_bufnr = vim.api.nvim_get_current_buf()
  local from = vim.api.nvim_buf_get_name(0)
  local root = require('jobin.config.custom.utils').get_git_root_buf() or vim.uv.cwd()
  local find_directory = function(opts, ctx)
    ---@diagnostic disable-next-line: missing-fields
    return require("snacks.picker.source.proc").proc({
      opts,
      {
        cmd = "fd",
        args = {
          "--type",
          "d",
          "--hidden",
          "--exclude",
          ".git",
          "--exclude",
          ".npm",
          "--exclude",
          "node_modules",
          ".",
          root,
        },
      },
    }, ctx)
  end

  local move = function(picker)
    picker:close()
    local item = picker:current()
    if not item then
      return
    end
    local dir = item.text
    local to = vim.fs.joinpath(dir, vim.fn.fnamemodify(from, ":t"))
    Snacks.rename.on_rename_file(from, to, function()
      local ok, err = pcall(vim.fn.rename, from, to)
      if not ok then
        Snacks.notify.error("Failed to move `" .. from .. "`:\n- " .. err)
      end
      vim.cmd.edit(to)
      vim.api.nvim_buf_delete(from_bufnr, { force = true })
    end)
  end

  ---@diagnostic disable-next-line: missing-fields
  Snacks.picker.pick({
    source = "move",
    title = "Move File",
    finder = find_directory,
    format = "text",
    confirm = move,
    preview = "none",
    layout = {
      preset = "select",
    },
  })
end

function M.second_brain()
  local second_brain_path = "~/playground/projects/second_brain/"
  Snacks.picker.files({
    cwd = second_brain_path,
    win = {
      input = {
        keys = {
          ["<C-Space>"] = { "create_file", mode = "i" },
        },
      },
    },
    actions = {
      create_file = function(picker, item)
        picker:close()
        local new_file = picker.finder.filter.pattern
        local new_file_path = vim.fs.joinpath(second_brain_path,
          vim.endswith(new_file, ".md") and new_file or new_file .. ".md")
        vim.cmd.edit(new_file_path)
      end
    }
  })
end

function M.second_brain_template()
  local template_file_path = "~/playground/projects/second_brain/Resources/Templates"
  Snacks.picker.files({
    cwd = template_file_path,
    confirm = function(picker, item)
      picker:close()
      vim.cmd('-1read ' .. vim.fs.joinpath(template_file_path, item.text))
      Snacks.notify.info(
        'Inserted ' .. vim.fs.basename(item.text)
      )
    end
  })
end

vim.keymap.set({ 'n', 'v' }, '<leader>rt', function() M.second_brain_template() end)
vim.keymap.set('n', '<leader>rr', ':update | luafile %<cr>')

return M
