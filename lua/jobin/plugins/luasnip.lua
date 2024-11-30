return {
  "L3MON4D3/LuaSnip",
  dependencies = {
    "rafamadriz/friendly-snippets",
  },
  -- follow latest release.
  -- version = "<CurrentMajor>.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
  -- install jsregexp (optional!).
  config = function()
    require('luasnip.loaders.from_vscode').lazy_load()
    require('luasnip.loaders.from_lua').load({ paths = { vim.fn.stdpath('config') .. '/snippets' } })
    local ls = require('luasnip')

    -- friendly-snippets - enable standardized comments snippets
    ls.filetype_extend("typescript", { "tsdoc" })
    ls.filetype_extend("javascript", { "jsdoc" })
    ls.filetype_extend("lua", { "luadoc" })
    ls.filetype_extend("python", { "pydoc" })
    ls.filetype_extend("rust", { "rustdoc" })
    ls.filetype_extend("cs", { "csharpdoc" })
    ls.filetype_extend("java", { "javadoc" })
    ls.filetype_extend("c", { "cdoc" })
    ls.filetype_extend("cpp", { "cppdoc" })
    ls.filetype_extend("php", { "phpdoc" })
    ls.filetype_extend("kotlin", { "kdoc" })
    ls.filetype_extend("ruby", { "rdoc" })
    ls.filetype_extend("sh", { "shelldoc" })

    ls.setup({
      history = true,
      delete_check_events = 'TextChanged',
      region_check_events = 'CursorMoved',
    })
  end
}
