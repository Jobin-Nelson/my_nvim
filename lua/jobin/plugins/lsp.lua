return {
  'neovim/nvim-lspconfig',
  event = { 'BufReadPost', 'BufNewFile' },
  dependencies = {
    { 'williamboman/mason.nvim', cmd = 'Mason', opts = { ui = { border = 'rounded' } } },
    'williamboman/mason-lspconfig.nvim',
    { 'j-hui/fidget.nvim',       opts = {} },
    'folke/neodev.nvim',
  },
  config = function()
    local on_attach = function(client, bufnr)
      local nmap = function(keys, func, desc)
        vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
      end

      nmap('<leader>lr', vim.lsp.buf.rename, 'Lsp Rename')
      nmap('<leader>la', vim.lsp.buf.code_action, 'Lsp code Action')

      nmap('gd', vim.lsp.buf.definition, 'Goto Definition')
      nmap('gr', require('telescope.builtin').lsp_references, 'Goto References')
      nmap('gI', vim.lsp.buf.implementation, 'Goto Implementation')
      nmap('gl', vim.diagnostic.open_float, 'Open diagnostic')
      nmap(']d', vim.diagnostic.goto_next, 'Next diagnostic')
      nmap('[d', vim.diagnostic.goto_prev, 'Previous diagnostic')
      nmap('<leader>gT', vim.lsp.buf.type_definition, 'Goto Type definition')
      nmap('<leader>lq', vim.diagnostic.setloclist, 'Set diagnostic quickfix')
      nmap('<leader>ld', require('telescope.builtin').diagnostics, 'Open diagnostic list')
      nmap('<leader>ls', require('telescope.builtin').lsp_document_symbols, 'Lsp Document Symbols')
      nmap('<leader>lS', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Lsp Workspace Symbols')
      nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
      nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
      nmap('gD', vim.lsp.buf.declaration, 'Goto Declaration')
      nmap('<leader>lwa', vim.lsp.buf.add_workspace_folder, 'Lsp Workspace Add folder')
      nmap('<leader>lwr', vim.lsp.buf.remove_workspace_folder, 'Lsp Workspace Remove folder')
      nmap('<leader>lwl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end, 'Lsp Workspace List folders')
      nmap('<leader>lf', vim.lsp.buf.format, 'Lsp Format buffer')

      -- Create a command `:Format` local to the LSP buffer
      -- vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
      --   vim.lsp.buf.format()
      -- end, { desc = 'Format current buffer with LSP' })

      -- if client.supports_method 'textDocument/inlayHint' then
      --   vim.lsp.inlay_hint.enable(bufnr, true)
      -- end
    end

    -- Diagnostics icons
    local icons = require('jobin.config.icons')
    local default_diagnostic_config = {
      signs = {
        active = true,
        values = {
          { name = "DiagnosticSignError", text = icons.diagnostics.BoldError },
          { name = "DiagnosticSignWarn",  text = icons.diagnostics.BoldWarning },
          { name = "DiagnosticSignHint",  text = icons.diagnostics.BoldHint },
          { name = "DiagnosticSignInfo",  text = icons.diagnostics.BoldInformation },
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
        source = "always",
        header = "",
        prefix = "",
      },
    }

    vim.diagnostic.config(default_diagnostic_config)

    for _, sign in ipairs(vim.tbl_get(vim.diagnostic.config(), "signs", "values") or {}) do
      vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = sign.name })
    end

    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
    require("lspconfig.ui.windows").default_options.border = "rounded"

    -- Servers
    local servers = {
      bashls = {},
      clangd = {},
      pyright = {},
      tsserver = {},
      emmet_ls = {},
      marksman = {},
      gopls = {},
      rust_analyzer = {
        cmd = { "rustup", "run", "stable", "rust-analyzer" },
      },
      lua_ls = {
        Lua = {
          diagnostics = {
            globals = { "vim" },
          },
          runtime = {
            version = "LuaJIT",
          },
          workspace = {
            checkThirdParty = false,
            library = {
              '${3rd}/luv/library',
              vim.env.VIMRUNTIME,
              -- [vim.fn.expand('$VIMRUNTIME/lua')] = true,
              -- [vim.fn.expand('config') .. '/lua'] = true,
            },
          },
          telemetry = { enable = false },
        },
      },
      jsonls = {
        settings = {
          json = {
            schemas = require('schemastore').json.schemas(),
          }
        },
      },
    }

    -- Setup neovim lua configuration
    require('neodev').setup()

    -- Ensure the servers above are installed
    local mason_lspconfig = require 'mason-lspconfig'

    mason_lspconfig.setup {
      ensure_installed = vim.tbl_keys(servers),
    }

    -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    -- for ufo
    capabilities.textDocument.foldingRange = {
      dynamicRegistration = false,
      lineFoldingOnly = true,
    }
    capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)


    mason_lspconfig.setup_handlers {
      function(server_name)
        require('lspconfig')[server_name].setup {
          capabilities = capabilities,
          on_attach = on_attach,
          settings = servers[server_name],
          filetypes = (servers[server_name] or {}).filetypes,
          cmd = servers[server_name].cmd
        }
      end,
    }
  end
}
