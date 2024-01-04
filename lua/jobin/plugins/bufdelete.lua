return {
  "famiu/bufdelete.nvim",
  event = "VeryLazy",
  config = function()
    -- keymap("n", "Q", "<cmd>Bdelete!<CR>", opts)
    vim.keymap.set("n", "<leader>c", ":lua require('bufdelete').bufdelete(0, false)<cr>", { desc = 'Bufdelete' })
  end
}
