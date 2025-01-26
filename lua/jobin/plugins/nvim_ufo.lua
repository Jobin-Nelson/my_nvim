return {
  'kevinhwang91/nvim-ufo',
  event = 'VeryLazy',
  dependencies = {
    'kevinhwang91/promise-async',
    {
      'luukvbaal/statuscol.nvim',
      config = function()
        local builtin = require('statuscol.builtin')
        require('statuscol').setup({
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
        })
      end
    }
  },
  init = function()
    vim.o.foldcolumn = '1'
    vim.o.foldlevel = 99
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true
    vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
  end,
  config = function()
    local handler = function(virtText, lnum, endLnum, width, truncate)
      local newVirtText = {}
      local suffix = string.format("  %d ", endLnum - lnum)
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

    local ftMap = {
      vim = 'indent',
      python = { 'indent' },
      alpha = '',
      git = '',
      org = '',
      markdown = '',
    }

    local function customizeSelector(bufnr)
      local function handleFallbackException(err, providerName)
        if type(err) == 'string' and err:match 'UfoFallbackException' then
          return require('ufo').getFolds(bufnr, providerName)
        else
          return require('promise').reject(err)
        end
      end

      return require('ufo')
          .getFolds(bufnr, 'lsp')
          :catch(function(err) return handleFallbackException(err, 'treesitter') end)
          :catch(function(err) return handleFallbackException(err, 'indent') end)
    end

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
      provider_selector = function(_, filetype, buftype)
        return ftMap[filetype] or customizeSelector
      end
    })

    -- vim.keymap.set('n', 'zR', require('ufo').openAllFolds, { desc = 'Open all folds' })
    -- vim.keymap.set('n', 'zM', require('ufo').closeAllFolds, { desc = 'Close all folds' })
    -- vim.keymap.set('n', 'zr', require('ufo').openFoldsExceptKinds, { desc = 'Fold less' })
    -- vim.keymap.set('n', 'zm', require('ufo').closeFoldsWith, { desc = 'Fold more' })
  end,
}
