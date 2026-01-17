return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    version = false,
    build = ':TSUpdate',
    lazy = false,
    opts_extend = { 'ensure_installed' },
    opts = {
      ensure_installed = {
        'python',
        'bash',
        'regex',
        'markdown',
        'markdown_inline',
        'json',
        'yaml',
        'lua',
        'toml',
        'make',
        'diff',
        'c',
        'html',
        'css',
        'javascript',
        'typescript',
        'tsx',
        'vim',
        'vimdoc',
        'query',
      },
    },
    config = function(_, opts)
      require('nvim-treesitter').install(opts.ensure_installed)
      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('treesitter.setup', { clear = true }),
        callback = function(args)
          local buf = args.buf
          local filetype = args.match


          -- you need some mechanism to avoid running on buffers that do not
          -- correspond to a language (like oil.nvim buffers), this implementation
          -- checks if a parser exists for the current language
          local language = vim.treesitter.language.get_lang(filetype) or filetype
          if not vim.treesitter.language.add(language) then
            return
          end

          -- replicate `fold = { enable = true }`
          vim.wo.foldmethod = 'expr'
          vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

          -- replicate `highlight = { enable = true }`
          vim.treesitter.start(buf, language)

          -- replicate `indent = { enable = true }`
          vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

          -- `incremental_selection = { enable = true }` cannot be easily replicated
        end,
      })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = 'main',
    -- event = 'VeryLazy',
    lazy = false,
    opts = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ["ak"] = { query = "@block.outer", group = 'textobjects', desc = "around block" },
          ["ik"] = { query = "@block.inner", group = 'textobjects', desc = "inside block" },
          ["ac"] = { query = "@class.outer", group = 'textobjects', desc = "around class" },
          ["ic"] = { query = "@class.inner", group = 'textobjects', desc = "inside class" },
          ["a?"] = { query = "@conditional.outer", group = 'textobjects', desc = "around conditional" },
          ["i?"] = { query = "@conditional.inner", group = 'textobjects', desc = "inside conditional" },
          ["af"] = { query = "@function.outer", group = 'textobjects', desc = "around function " },
          ["if"] = { query = "@function.inner", group = 'textobjects', desc = "inside function " },
          ["al"] = { query = "@loop.outer", group = 'textobjects', desc = "around loop" },
          ["il"] = { query = "@loop.inner", group = 'textobjects', desc = "inside loop" },
          ["aa"] = { query = "@parameter.outer", group = 'textobjects', desc = "around argument" },
          ["ia"] = { query = "@parameter.inner", group = 'textobjects', desc = "inside argument" },
        }
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        keymaps = {
          goto_next_start = {
            ["]k"] = { query = "@block.outer", group = 'textobjects', desc = "Next block start" },
            ["]f"] = { query = "@function.outer", group = 'textobjects', desc = "Next function start" },
            -- ["]a"] = { query = "@parameter.inner", group = 'textobjects', desc = "Next argument start" },
            ["]]"] = { query = "@class.outer", group = 'textobjects', desc = "Next class start" },
            ["]z"] = { query = "@fold", group = 'folds', desc = "Next fold start" },
          },
          goto_next_end = {
            ["]K"] = { query = "@block.outer", group = 'textobjects', desc = "Next block end" },
            ["]F"] = { query = "@function.outer", group = 'textobjects', desc = "Next function end" },
            -- ["]A"] = { query = "@parameter.inner", group = 'textobjects', desc = "Next argument end" },
            ["]["] = { query = "@class.outer", group = 'textobjects', desc = "Next class end" },
          },
          goto_previous_start = {
            ["[k"] = { query = "@block.outer", group = 'textobjects', desc = "Previous block start" },
            ["[f"] = { query = "@function.outer", group = 'textobjects', desc = "Previous function start" },
            -- ["[a"] = { query = "@parameter.inner", group = 'textobjects', desc = "Previous argument start" },
            ["[["] = { query = "@class.outer", group = 'textobjects', desc = "Previous class start" },
          },
          goto_previous_end = {
            ["[K"] = { query = "@block.outer", group = 'textobjects', desc = "Previous block end" },
            ["[F"] = { query = "@function.outer", group = 'textobjects', desc = "Previous function end" },
            -- ["[A"] = { query = "@parameter.inner", group = 'textobjects', desc = "Previous argument end" },
            ["[]"] = { query = "@class.outer", group = 'textobjects', desc = "Previous class end" },
          },
        }
      },
      swap = {
        enable = true,
        keymaps = {
          swap_next = {
            [">K"] = { query = "@block.outer", group = 'textobjects', desc = "Swap next block" },
            [">F"] = { query = "@function.outer", group = 'textobjects', desc = "Swap next function" },
            [">A"] = { query = "@parameter.inner", group = 'textobjects', desc = "Swap next argument" },
          },
          swap_previous = {
            ["<K"] = { query = "@block.outer", group = 'textobjects', desc = "Swap previous block" },
            ["<F"] = { query = "@function.outer", group = 'textobjects', desc = "Swap previous function" },
            ["<A"] = { query = "@parameter.inner", group = 'textobjects', desc = "Swap previous argument" },
          },
        }
      },
    },
    config = function(_, opts)
      require('nvim-treesitter-textobjects').setup(opts)

      local select = require('nvim-treesitter-textobjects.select').select_textobject

      for key, query_obj in pairs(opts.select.keymaps) do
        vim.keymap.set({ 'x', 'o' }, key, function()
          select(query_obj.query, query_obj.group)
        end, { desc = query_obj.desc })
      end

      for seg, keymap in pairs(opts.move.keymaps) do
        for key, query_obj in pairs(keymap) do
          vim.keymap.set({ "n", "x", "o" }, key, function()
            require("nvim-treesitter-textobjects.move")[seg](query_obj.query, query_obj.group)
          end, { desc = query_obj.desc })
        end
      end

      for seg, keymap in pairs(opts.swap.keymaps) do
        for key, query_obj in pairs(keymap) do
          vim.keymap.set("n", key, function()
            require("nvim-treesitter-textobjects.swap")[seg](query_obj.query, query_obj.group)
          end, { desc = query_obj.desc })
        end
      end
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = { 'BufReadPre', 'BufNewFile' },
    opts = { mode = "cursor", max_lines = 3 },
  },
  {
    "windwp/nvim-ts-autotag",
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {},
  }
}
