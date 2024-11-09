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

local autosnippets = {}

-- Snippets go here

local snippets = {
  s({ trig = 'box' },
    fmt([[
    -- #=={}==#
    -- #  {}  #
    -- #=={}==#


]], {
      d(2, function(value)
        return sn(nil, t(string.rep('=', string.len(value[1][1]))))
      end, { 1 }), i(1),
      rep(2),
    })
  ),
}

-- End snippets

return snippets, autosnippets
