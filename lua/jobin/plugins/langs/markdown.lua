return {
  -- lsp
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        'marksman'
      }
    },
  },

  -- format
  {
  'stevearc/conform.nvim',
    opts = function(_, opts)
      opts.formatters_by_ft.markdown = { "prettier" }
    end,
  },

  {
    "HakonHarnes/img-clip.nvim",
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
  },
}
