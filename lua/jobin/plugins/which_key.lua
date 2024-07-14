return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  opts = {
    defaults = {
      preset = "modern",
    },
    spec = {
      { "<leader>f", group = "Find",     nowait = true, remap = false },
      { "<leader>b", group = "Buffers",  nowait = true, remap = false },
      { "<leader>l", group = "Lsp",      nowait = true, remap = false },
      { "<leader>p", group = "Package",  nowait = true, remap = false },
      { "<leader>t", group = "Terminal", nowait = true, remap = false },
      { "<leader>w", group = "Work",     nowait = true, remap = false },
      { "<leader>j", group = "Custom",   nowait = true, remap = false },
      { "<leader>g", group = "Git",      nowait = true, remap = false },
      { "<leader>d", group = "Debug",    nowait = true, remap = false },
      { "<leader>u", group = "UI",       nowait = true, remap = false },
      { "<leader>o", group = "Org mode", nowait = true, remap = false },
      { "<leader>s", group = "Session",  nowait = true, remap = false },
    }
  },
}
