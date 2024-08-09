return {
  'kevinhwang91/nvim-ufo',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    'kevinhwang91/promise-async',
    'luukvbaal/statuscol.nvim',
  },
  config = function()
    local builtin = require('statuscol.builtin')
    local cfg = {
      setopt = true,
      relculright = true,
      bt_ignore = {
        'terminal',
      },
      ft_ignore = {
        'toggleterm',
        'alpha',
        'NvimTree',
        'man',
      },
      segments = {
        { text = { builtin.foldfunc, ' ' }, click = 'v:lua.ScFa', hl = 'Comment' },
        { text = { "%s" },                  click = "v:lua.ScSa" },
        { text = { builtin.lnumfunc, ' ' }, click = "v:lua.ScLa" },
      }
    }
    require('statuscol').setup(cfg)

    vim.o.foldcolumn = '1'
    vim.o.foldlevel = 99
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true
    vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]

    local handler = function(virtText, lnum, endLnum, width, truncate)
      local newVirtText = {}
      local suffix = (' 󰁂 %d '):format(endLnum - lnum)
      local sufWidth = vim.fn.strdisplaywidth(suffix)
      local targetWidth = width - sufWidth
      local curWidth = 0
      for _, chunk in ipairs(virtText) do
        local chunkText = chunk[1]
        local chunkWidth = vim.fn.strdisplaywidth(chunkText)
        if targetWidth > curWidth + chunkWidth then
          table.insert(newVirtText, chunk)
        else
          chunkText = truncate(chunkText, targetWidth - curWidth)
          local hlGroup = chunk[2]
          table.insert(newVirtText, { chunkText, hlGroup })
          chunkWidth = vim.fn.strdisplaywidth(chunkText)
          -- str width returned from truncate() may less than 2nd argument, need padding
          if curWidth + chunkWidth < targetWidth then
            suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
          end
          break
        end
        curWidth = curWidth + chunkWidth
      end
      table.insert(newVirtText, { suffix, 'MoreMsg' })
      return newVirtText
    end

    -- global handler
    -- `handler` is the 2nd parameter of `setFoldVirtTextHandler`,
    -- check out `./lua/ufo.lua` and search `setFoldVirtTextHandler` for detail.

    -- buffer scope handler
    -- will override global handler if it is existed
    -- local bufnr = vim.api.nvim_get_current_buf()
    -- require('ufo').setFoldVirtTextHandler(bufnr, handler)

    local ftMap = {
      -- vim = 'indent',
      -- python = {'indent'},
      alpha = '',
      git = '',
      org = '',
      markdown = '',
    }
    ---@diagnostic disable-next-line: missing-fields
    require('ufo').setup({
      fold_virt_text_handler = handler,
      open_fold_hl_timeout = 150,
      close_fold_kinds = {},
      preview = {
        win_config = {
          border = { '', '─', '', '', '', '─', '', '' },
          winhighlight = 'Normal:Folded',
          winblend = 0
        },
        mappings = {
          scrollU = '<C-u>',
          scrollD = '<C-d>',
          jumpTop = '[',
          jumpBot = ']'
        }
      },
      provider_selector = function(bufnr, filetype, buftype)
        -- if you prefer treesitter provider rather than lsp,
        -- return ftMap[filetype] or {'treesitter', 'indent'}
        return ftMap[filetype]

        -- refer to ./doc/example.lua for detail
      end
    })

    vim.keymap.set('n', 'zR', require('ufo').openAllFolds, { desc = 'Open all folds' })
    vim.keymap.set('n', 'zM', require('ufo').closeAllFolds, { desc = 'Close all folds' })
    vim.keymap.set('n', 'zr', require('ufo').openFoldsExceptKinds, { desc = 'Fold less' })
    vim.keymap.set('n', 'zm', require('ufo').closeFoldsWith, { desc = 'Fold more' })
    -- vim.keymap.set('n', 'K', function()
    --   local winid = require('ufo').peekFoldedLinesUnderCursor()
    --   if not winid then
    --     vim.lsp.buf.hover()
    --   end
    -- end)
  end,

}
