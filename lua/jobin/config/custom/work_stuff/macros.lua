-- macros
vim.fn.setreg('j', [[0f[x;"adi[h3xF["apa|j]]) -- convert org link to jira link
vim.fn.setreg('m', [[$hhdi[Bi[P](l2xf]C)j]]) -- convert org link to markdown link

-- mappings
vim.keymap.set('n', 'yl', '0$hhyi[0', { desc = 'Copy Test-Case ID', silent = true })
