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
    dependencies = {
      'zbirenbaum/copilot.lua',
      "nvim-lua/plenary.nvim",
    },
    keys = {
      { "<leader>a", "", desc = "+ai", mode = { "n", "v" } },
      {
        "<leader>aa",
        function()
          return require("CopilotChat").toggle()
        end,
        desc = "Toggle (CopilotChat)",
        mode = { "n", "v" },
      },
      {
        "<leader>ax",
        function()
          return require("CopilotChat").reset()
        end,
        desc = "Clear (CopilotChat)",
        mode = { "n", "v" },
      },
      {
        "<leader>aq",
        function()
          vim.ui.input({
            prompt = "Quick Chat: ",
          }, function(input)
            if input ~= "" then
              require("CopilotChat").ask(input)
            end
          end)
        end,
        desc = "Quick Chat (CopilotChat)",
        mode = { "n", "v" },
      },
      {
        "<leader>ap",
        function()
          require("CopilotChat").select_prompt()
        end,
        desc = "Prompt Actions (CopilotChat)",
        mode = { "n", "v" },
      },
      {
        "<leader>a?",
        function()
          require("CopilotChat").select_model()
        end,
        desc = "Select Model (CopilotChat)",
      },
    },
    opts = function()
      return {
        auto_insert_mode = true,
        question_header = "  " .. (vim.env.USER or 'Me') .. " ",
        answer_header = "  Copilot ",
        window = {
          width = 0.4,
        },
        prompts = {
          MyCustomPrompt = {
            prompt = 'Explain how it works.',
            system_prompt = 'You are very good at explaining stuff',
            mapping = '<leader>acmc',
            description = 'My custom prompt description',
          }
        },
        providers = {
          ollama = {
            prepare_input = require('CopilotChat.config.providers').copilot.prepare_input,
            prepare_output = require('CopilotChat.config.providers').copilot.prepare_output,

            get_models = function(headers)
              local response, err = require('CopilotChat.utils').curl_get('http://localhost:11434/v1/models', {
                headers = headers,
                json_response = true,
              })

              if err then
                error(err)
              end

              return vim.tbl_map(function(model)
                return {
                  id = model.id,
                  name = model.id,
                }
              end, response.body.data)
            end,

            embed = function(inputs, headers)
              local response, err = require('CopilotChat.utils').curl_post('http://localhost:11434/v1/embeddings', {
                headers = headers,
                json_request = true,
                json_response = true,
                body = {
                  input = inputs,
                  model = 'all-minilm',
                },
              })

              if err then
                error(err)
              end

              return response.body.data
            end,

            get_url = function()
              return 'http://localhost:11434/v1/chat/completions'
            end,
          }
        }
      }
    end
  },
}
