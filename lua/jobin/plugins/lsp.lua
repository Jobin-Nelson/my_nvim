return {
  'neovim/nvim-lspconfig',
  event = { 'BufReadPost', 'BufNewFile' },
  dependencies = {
    'b0o/schemastore.nvim',
    'saghen/blink.cmp',
    {
      'j-hui/fidget.nvim',
      opts = {
        progress = {
          display = {
            render_limit = 16, -- How many LSP messages to show at once
            done_ttl = 3,      -- How long a message should persist after completion
            done_icon = '✔',
            progress_icon = { pattern = 'meter', period = 1 },
          },
        },
        notification = {
          poll_rate = 60, -- FPS
          view = {
            stack_upwards = true,
            icon_separator = " ",
            group_separator = "---",
          },
          window = {
            normal_hl = "Comment", -- Base highlight group in the notification window
            winblend = 0,          -- Background color opacity in the notification window
            border = "single",     -- Border around the notification window
            x_padding = 1,
            y_padding = 0,
            relative = "editor",
          },
        },
      }
    }
  },
  opts = {
    servers = {
      'lua_ls',
      'jsonls',
      'yamlls',
      'bashls',
      'marksman',
      'nil_ls',
      -- ts_ls = {},
      -- emmet_ls = {},
      -- rust_analyzer = {},
      -- gopls = {},
      -- clangd = {},
      -- dockerls = {},
      -- sqlls = {},
      -- groovyls = {},
      -- hls = {},
    }
  },
  config = function(_, opts)
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('Lsp-Attach-KeyMaps', { clear = true }),
      callback = function(args)
        local map = function(keys, func, desc, mode)
          vim.keymap.set(mode or 'n', keys, func, { buffer = args.buf, desc = desc })
        end

        -- Fzf mappings
        map('gd', '<cmd>FzfLua lsp_definitions jump1=true ignore_current_line=true<cr>',
          'Goto [D]efinition')
        map('grr', '<cmd>FzfLua lsp_references jump1=true ignore_current_line=true<cr>',
          'Goto [R]eferences')
        map('gri', '<cmd>FzfLua lsp_implementations jump1=true ignore_current_line=true<cr>',
          'Goto [I]mplementation')
        map('gy', '<cmd>FzfLua lsp_typedefs jump1=true ignore_current_line=true<cr>',
          'Goto T[y]pe Definition')
        map('<leader>ld', '<cmd>FzfLua diagnostics_document jump1=true<cr>',
          'Open [D]iagnostic Buffer')
        map('<leader>lD', '<cmd>FzfLua diagnostics_workspace<cr>', 'Open [D]iagnostics Workspace')
        map('<leader>ls', '<cmd>FzfLua lsp_document_symbols jump1=true<cr>',
          'Lsp Document Symbols')
        map('<leader>lS',
          '<cmd>FzfLua lsp_live_workspace_symbols jump1=true ignore_current_line=true<cr>',
          'Lsp Workspace Symbols')

        -- Snacks mappings
        -- map("gd", function() Snacks.picker.lsp_definitions() end, "Goto Definition")
        -- map("grr", function() Snacks.picker.lsp_references() end,  "References" )
        -- map("gri", function() Snacks.picker.lsp_implementations() end, "Goto Implementation")
        -- map("gy", function() Snacks.picker.lsp_type_definitions() end, "Goto T[y]pe Definition")
        -- map("<leader>ls", function() Snacks.picker.lsp_symbols() end, "LSP Symbols")
        -- map("<leader>lS", function() Snacks.picker.lsp_workspace_symbols() end, "LSP Workspace Symbols")

        map(']d', function() vim.diagnostic.jump({ count = 1, float = true }) end, 'Next diagnostic')
        map('[d', function() vim.diagnostic.jump({ count = -1, float = true }) end, 'Previous diagnostic')
        map('gD', vim.lsp.buf.declaration, 'Goto [D]eclaration')
        map('<leader>lq', vim.diagnostic.setloclist, 'Set diagnostic quickfix')
        map('K', function() vim.lsp.buf.hover({ border = 'rounded' }) end, 'Hover Documentation')
        map('<C-s>', function() vim.lsp.buf.signature_help({ border = 'rounded' }) end, 'Signature Documentation', 'i')

        map('<leader>la', vim.lsp.buf.code_action, 'Code Action', { 'n', 'v' })
        map('<leader>lA', function()
            vim.lsp.buf.code_action(
              {
                apply = true,
                context = {
                  only = { 'source' },
                  diagnostics = {},
                },
              })
          end,
          'Source Action')
        map('<leader>ll', vim.lsp.codelens.run, 'Run CodeLens', { 'n', 'v' })
        map('<leader>lL', vim.lsp.codelens.refresh, 'Refresh & Display CodeLens', { 'n', 'v' })

        map('<leader>lwa', vim.lsp.buf.add_workspace_folder, 'Lsp Workspace Add folder')
        map('<leader>lwr', vim.lsp.buf.remove_workspace_folder, 'Lsp Workspace Remove folder')
        map('<leader>lwl', function()
          vim.notify(
            vim.inspect(vim.lsp.buf.list_workspace_folders()),
            vim.log.levels.INFO,
            { title = 'LSP' }
          )
        end, 'Lsp Workspace List folders')

        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client then return end

        if client:supports_method('textDocument/foldingRange') then
          local win = vim.api.nvim_get_current_win()
          vim.wo[win][0].foldexpr = 'v:lua.vim.lsp.foldexpr()'
        end

        if client:supports_method('textDocument/codeLens') then
          vim.lsp.codelens.refresh()
          vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
            buffer = args.buf,
            callback = vim.lsp.codelens.refresh,
          })
        end
      end,
      desc = 'Create keymaps for lsp attached buffers',
    })

    vim.api.nvim_create_autocmd({ "LspDetach" }, {
      group = vim.api.nvim_create_augroup("LspStopWithLastClient", {}),
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client or not client.attached_buffers then return end
        for buf_id in pairs(client.attached_buffers) do
          if buf_id ~= args.buf then return end
        end
        client:stop()
      end,
      desc = "Stop lsp client when no buffer is attached",
    })

    -- Diagnostics icons
    local icons = require('jobin.config.icons')
    vim.diagnostic.config {
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = icons.diagnostics.BoldError,
          [vim.diagnostic.severity.WARN] = icons.diagnostics.BoldWarning,
          [vim.diagnostic.severity.HINT] = icons.diagnostics.BoldHint,
          [vim.diagnostic.severity.INFO] = icons.diagnostics.BoldInformation,
        },
      },
      virtual_text = true,
      update_in_insert = false,
      underline = true,
      severity_sort = true,
      float = {
        focusable = true,
        style = "minimal",
        border = "rounded",
        source = true,
        header = "",
        prefix = "",
      },
    }

    require("lspconfig.ui.windows").default_options.border = "rounded"

    -- blink.cmp supports additional completion capabilities, so broadcast that to servers
    local capabilities = {
      workspace = {
        fileOperations = {
          didRename = true,
          willRename = true,
        }
      }
    }
    vim.lsp.config('*', {
      capabilities = require('blink.cmp').get_lsp_capabilities(capabilities)
    })
    -- for ufo
    -- capabilities.textDocument.foldingRange = {
    --   dynamicRegistration = false,
    --   lineFoldingOnly = true,
    -- }

    vim.lsp.enable(opts.servers)
  end
}
