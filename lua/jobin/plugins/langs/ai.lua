return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      suggestion = {
        enabled = false,
        auto_trigger = false,
        keymap = {
          accept_line = "<M-e>",
          accept_word = "<M-w>",
          accept = "<M-l>",
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
      },
      panel = { enabled = false },
    }
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "main",
    cmd = "CopilotChat",
    opts = {
      auto_insert_mode = true,
      question_header = "  " .. (vim.env.USER or 'User') .. " ",
      answer_header = "  Copilot ",
      window = {
        width = 0.4,
      },
    },
  },
  -- {
  --   "olimorris/codecompanion.nvim",
  --   opts = {
  --     strategies = {
  --       chat = {
  --         roles = {
  --           ---The header name for the LLM's messages
  --           ---@type string|fun(adapter: CodeCompanion.Adapter): string
  --           llm = function(adapter)
  --             return "  CodeCompanion  " .. adapter.formatted_name
  --           end,
  --           ---The header name for your messages
  --           ---@type string
  --           user = "  " .. (vim.env.USER or 'Me'),
  --         }
  --       }
  --     }
  --   },
  --   cmd = {
  --     'CodeCompanion',
  --     'CodeCompanionChat',
  --     'CodeCompanionCmd',
  --     'CodeCompanionActions',
  --   },
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "nvim-treesitter/nvim-treesitter",
  --     {
  --       "HakonHarnes/img-clip.nvim",
  --       opts = {
  --         filetypes = {
  --           codecompanion = {
  --             prompt_for_file_name = false,
  --             template = "[Image]($FILE_PATH)",
  --             use_absolute_path = true,
  --           },
  --         }
  --       }
  --     },
  --   },
  --   config = function(_, opts)
  --     require('codecompanion').setup(opts)
  --
  --     local progress = require('fidget.progress')
  --     local handles = {}
  --     local group = vim.api.nvim_create_augroup("jobin/CodeCompanionFidget", { clear = true })
  --     vim.api.nvim_create_autocmd('User', {
  --       pattern = 'CodeCompanionRequestStarted',
  --       group = group,
  --       callback = function(e)
  --         handles[e.data.id] = progress.handle.create({
  --           title = '  CodeCompanion',
  --           message = '󰆄  Thinking ... ',
  --           lsp_client = { name = e.data.adapter.formatted_name },
  --         })
  --       end
  --     })
  --     vim.api.nvim_create_autocmd('User', {
  --       pattern = 'CodeCompanionRequestFinished',
  --       group = group,
  --       callback = function(e)
  --         local h = handles[e.data.id]
  --         if h then
  --           h.message = e.data.status == 'success' and 'Done' or 'Failed'
  --           h:finish()
  --           handles[e.data.id] = nil
  --         end
  --       end
  --     })
  --   end
  -- },
}
