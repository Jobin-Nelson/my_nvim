return {
  'williamboman/mason-lspconfig.nvim',
  event = { 'BufReadPost', 'BufNewFile' },
  dependencies = {
    { 'williamboman/mason.nvim', cmd = 'Mason', opts = { ui = { border = 'rounded' } } },
    'neovim/nvim-lspconfig',
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
  config = function()
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('Lsp-Attach-KeyMaps', { clear = true }),
      callback = function(args)
        local map = function(keys, func, desc, mode)
          vim.keymap.set(mode or 'n', keys, func, { buffer = args.buf, desc = desc })
        end

        map('grn', vim.lsp.buf.rename, 'Lsp Rename')
        map('gra', vim.lsp.buf.code_action, 'Lsp code Action')

        -- Fzf mappings
        -- map('gd', '<cmd>FzfLua lsp_definitions jump_to_single_result=true ignore_current_line=true<cr>',
        --   'Goto [D]efinition')
        -- map('grr', '<cmd>FzfLua lsp_references jump_to_single_result=true ignore_current_line=true<cr>',
        --   'Goto [R]eferences')
        -- map('gri', '<cmd>FzfLua lsp_implementations jump_to_single_result=true ignore_current_line=true<cr>',
        --   'Goto [I]mplementation')
        -- map('gy', '<cmd>FzfLua lsp_typedefs jump_to_single_result=true ignore_current_line=true<cr>',
        --   'Goto T[y]pe Definition')
        -- map('<leader>ld', '<cmd>FzfLua diagnostics_document jump_to_single_result=true ignore_current_line=true<cr>',
        --   'Open diagnostic list')
        -- map('<leader>ls', '<cmd>FzfLua lsp_document_symbols jump_to_single_result=true ignore_current_line=true<cr>',
        --   'Lsp Document Symbols')
        -- map('<leader>lS',
        --   '<cmd>FzfLua lsp_live_workspace_symbols jump_to_single_result=true ignore_current_line=true<cr>',
        --   'Lsp Workspace Symbols')

        -- Snacks mappings
        map("gd", function() Snacks.picker.lsp_definitions() end, "Goto Definition")
        map("grr", function() Snacks.picker.lsp_references() end,  "References" )
        map("gri", function() Snacks.picker.lsp_implementations() end, "Goto Implementation")
        map("gy", function() Snacks.picker.lsp_type_definitions() end, "Goto T[y]pe Definition")
        map("<leader>ls", function() Snacks.picker.lsp_symbols() end, "LSP Symbols")
        map("<leader>lS", function() Snacks.picker.lsp_workspace_symbols() end, "LSP Workspace Symbols")

        map('gD', vim.lsp.buf.declaration, 'Goto [D]eclaration')
        map(']d', vim.diagnostic.goto_next, 'Next diagnostic')
        map('[d', vim.diagnostic.goto_prev, 'Previous diagnostic')
        map('<leader>lq', vim.diagnostic.setloclist, 'Set diagnostic quickfix')
        map('K', vim.lsp.buf.hover, 'Hover Documentation')
        map('<C-s>', vim.lsp.buf.signature_help, 'Signature Documentation', 'i')
        map('<leader>lwa', vim.lsp.buf.add_workspace_folder, 'Lsp Workspace Add folder')
        map('<leader>lwr', vim.lsp.buf.remove_workspace_folder, 'Lsp Workspace Remove folder')
        map('<leader>lwl', function()
          vim.notify(
            vim.inspect(vim.lsp.buf.list_workspace_folders()),
            vim.log.levels.INFO,
            { title = 'LSP' }
          )
        end, 'Lsp Workspace List folders')
      end
    })

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
      lua_ls = {
        Lua = {
          diagnostics = {
            globals = { "vim" },
          },
          completion = {
            callSnippet = 'Replace',
          },
          workspace = {
            checkThirdParty = false,
          },
          doc = {
            privateName = { '^_' },
          },
        },
      },
      jsonls = {
        settings = {
          json = {
            -- For more manual selection of schemas visit
            -- https://www.arthurkoziel.com/json-schemas-in-neovim/
            schemas = require('schemastore').json.schemas(),
            validate = { enable = true },
          }
        },
      },
      yamlls = {
        settings = {
          yaml = {
            validate = true,
            keyOrdering = false,
            schemaStore = {
              -- You must disable built-in schemaStore support if you want to use
              -- this plugin and its advanced options like `ignore`.
              enable = false,
              -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
              url = "",
            },
            -- schemas = require('schemastore').yaml.schemas(),
            schemas = {
              kubernetes = "*.yaml",
              ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
              ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
              ["http://json.schemastore.org/ansible-stable-2.9"] = "roles/*/tasks/*.{yml,yaml}",
              ["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
              ["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
              ["http://json.schemastore.org/ansible-playbook"] = "*play*.{yml,yaml}",
              ["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
              ["https://json.schemastore.org/dependabot-v2"] = ".github/dependabot.{yml,yaml}",
              ["https://json.schemastore.org/gitlab-ci"] = "*gitlab-ci*.{yml,yaml}",
              ["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json"] =
              "*api*.{yml,yaml}",
              ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] =
              "*docker-compose*.{yml,yaml}",
              ["https://raw.githubusercontent.com/argoproj/argo-workflows/master/api/jsonschema/schema.json"] =
              "*flow*.{yml,yaml}",
            },
          },
        },
      },
      -- bashls = {},
      -- pyright = {},
      -- ts_ls = {},
      -- emmet_ls = {},
      -- marksman = {},
      -- rust_analyzer = {},
      -- gopls = {},
      -- clangd = {},
      -- dockerls = {},
      -- sqlls = {},
      -- groovyls = {},
      -- hls = {},
    }

    local mason_lspconfig = require 'mason-lspconfig'
    mason_lspconfig.setup()

    -- blink.cmp supports additional completion capabilities, so broadcast that to servers
    local capabilities = require('blink.cmp').get_lsp_capabilities()
    -- for ufo
    capabilities.textDocument.foldingRange = {
      dynamicRegistration = false,
      lineFoldingOnly = true,
    }

    mason_lspconfig.setup_handlers {
      function(server_name)
        local server = servers[server_name] or {}
        server.capabilities = capabilities
        require('lspconfig')[server_name].setup(server)
      end,
      -- rust_analyzer will be set up by rustaceanvim
      ['rust_analyzer'] = function() end,
    }
  end
}
