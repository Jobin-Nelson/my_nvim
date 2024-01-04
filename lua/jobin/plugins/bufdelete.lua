return {
  "famiu/bufdelete.nvim",
  event = "VeryLazy",
  config = function()
    local keymap = vim.keymap.set
    local opts = { noremap = true, silent = true }
    -- keymap("n", "Q", "<cmd>Bdelete!<CR>", opts)
    keymap("n", "<leader>c", ":lua require('bufdelete').bufdelete(0, false)<cr>", opts)
  end
}
