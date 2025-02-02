-- macros
vim.fn.setreg('j', [[0f[x;"adi[h3xF["apa|j]]) -- convert org link to jira link
vim.fn.setreg('m', [[$hhdi[Bi[P](l2xf]C)j]]) -- convert org link to markdown link
vim.fn.setreg('o', "$xa]]F(r[hca[[$P0") -- convert markdown link to org link 

-- mappings
vim.keymap.set('n', 'yl', "$F[yi[", { desc = 'Copy Test-Case ID', silent = true })
