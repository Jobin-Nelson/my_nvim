local ls = require('luasnip')
local s = ls.s
local i = ls.i
local t = ls.t

local d = ls.dynamic_node
local c = ls.choice_node
local f = ls.function_node
local sn = ls.snippet_node

local fmt = require('luasnip.extras.fmt').fmt
local rep = require('luasnip.extras').rep

local utils = require('jobin.config.custom.utils')

local autosnippets = {}

-- Snippets go here

local snippets = {
  s('title',
    f(function()
      return utils.titleCaseLine(vim.fn.expand('%:t:r')
        :gsub('_', ' '))
    end)
  ),
  s('t',
    t({ '', '- [ ] ' })
  ),
}

-- End snippets

return snippets, autosnippets
