return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = {
          enabled = false,
          auto_trigger = true,
        },
        panel = { enabled = false },
      })
    end,
  },
  {
    "giuxtaposition/blink-cmp-copilot",
    dependencies = { "zbirenbaum/copilot.lua" },
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
  }
}
