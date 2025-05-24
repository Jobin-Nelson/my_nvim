return {
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        'marksman'
      }
    },
  },
  {
    "HakonHarnes/img-clip.nvim",
    event = "VeryLazy",
    opts = {
      -- add options here
      -- or leave it empty to use the default settings
      dir_path = function()
        if vim.api.nvim_buf_get_name(0):match('second_brain') then
          return 'Resources/attachments'
        end

        return 'assets'
      end
    },
    keys = {
      -- suggested keymap
      { "<leader>p", "<cmd>PasteImage<cr>", desc = "Paste image from system clipboard" },
    },
  }
}
