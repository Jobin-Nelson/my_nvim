return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    keys = {
      { "<leader>t",  "",                                                                                 desc = "+test" },
      { "<leader>tt", function() require("neotest").run.run(vim.fn.expand("%")) end,                      desc = "Run File" },
      { "<leader>tT", function() require("neotest").run.run(vim.uv.cwd()) end,                            desc = "Run All Test Files" },
      { "<leader>tr", function() require("neotest").run.run() end,                                        desc = "Run Nearest" },
      { "<leader>tl", function() require("neotest").run.run_last() end,                                   desc = "Run Last" },
      { "<leader>ts", function() require("neotest").summary.toggle() end,                                 desc = "Toggle Summary" },
      { "<leader>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Show Output" },
      { "<leader>tO", function() require("neotest").output_panel.toggle() end,                            desc = "Toggle Output Panel" },
      { "<leader>tS", function() require("neotest").run.stop() end,                                       desc = "Stop" },
      { "<leader>tw", function() require("neotest").watch.toggle(vim.fn.expand("%")) end,                 desc = "Toggle Watch" },
    },
    opts = {
      adapters = {},
      status = { virtual_text = true },
      output = { open_on_run = true },
    },
  },
  {
    "mfussenegger/nvim-dap",
    optional = true,
    keys = {
      { "<leader>td", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "Debug Nearest" },
    },
  }
}
