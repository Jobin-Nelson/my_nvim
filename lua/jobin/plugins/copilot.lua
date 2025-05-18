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
  }
}
