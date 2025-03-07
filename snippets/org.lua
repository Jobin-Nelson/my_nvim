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
  s('title', {
    f(function()
      local file_name = string.gsub(vim.fn.expand('%:t:r'), '_', ' ')
      -- %f:  frontier pattern which matches the transition between a character that 
      --      is not a part of a specific set and a character that is within a set
      --      below %f[%l] matches first lower case character in a string
      return '#+TITLE:     ' .. string.gsub(file_name, '%f[%l].', string.upper)
    end),
    t { '',
      '#+AUTHOR:    Jobin Nelson',
      '#+EMAIL:     jnelson4@illumina.com',
      '#+ARCHIVE:   ~/playground/dev/illumina/ticket_notes/work_org_files/work_archive.org_archive',
      '', '' },
  }),
  s({ trig = 'jbug' },
    fmt([[
*Test Environment*: {}

*Build version*: {}

*Expected Result*: {}

*Actual Result*: {}

*Pre-condition*:
{}

*Steps to reproduce*:
{}

*Observation*:
{}

*Workaround/Fix*:
{}

*Logs*:
{}

]], {
        i(1),
        i(2),
        i(3),
        i(4),
        i(5),
        i(6),
        i(7),
        i(8),
        i(9),
    })
  ),
}

-- End snippets

return snippets, autosnippets
