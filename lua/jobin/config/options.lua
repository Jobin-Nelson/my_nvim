vim.opt.showmode = false
vim.opt.hlsearch = false
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.mouse = 'a'
vim.opt.clipboard = 'unnamedplus'
vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.breakindentopt = 'list:2,min:20,sbr'
-- vim.opt.showbreak = '> '
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = 'yes'
vim.opt.backup = false
vim.opt.updatecount = 0
vim.opt.completeopt = 'menu,menuone,noinsert,noselect'
vim.opt.termguicolors = true
vim.opt.conceallevel = 2
vim.opt.signcolumn = 'yes'
vim.opt.laststatus = 3
-- vim.opt.statuscolumn = '%=%C%s%{v:relnum?v:relnum:v:lnum } '
vim.o.fillchars = 'eob: ,fold: ,foldopen:,foldsep: ,foldclose:'
-- vim.opt.foldcolumn = '1'
-- vim.opt.winbar = '%=%m %t'
-- vim.opt.winbar = "%t  %{%v:lua.require'nvim-navic'.get_location()%}"
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.incsearch = true
vim.opt.undodir = vim.fn.stdpath('config') .. '/undodir'
vim.opt.undofile = true
vim.opt.swapfile = false
vim.opt.pumheight = 10
vim.opt.pumblend = 0
vim.opt.sessionoptions = 'curdir,folds,globals,help,tabpages,terminal,winsize'
-- vim.opt.iskeyword = vim.opt.iskeyword + '-'
vim.opt.formatoptions = vim.opt.formatoptions
  - "a" -- Auto formatting is BAD.
  - "t" -- Don't auto format my code. I got linters for that.
  + "c" -- In general, I like it when comments respect textwidth
  + "q" -- Allow formatting comments w/ gq
  - "o" -- O and o, don't continue comments
  + "r" -- But do continue when pressing enter.
  + "n" -- Indent past the formatlistpat, not underneath it.
  + "j" -- Auto-remove comments if possible.
  - "2" -- I'm not in gradeschool anymore
vim.g.markdown_folding = 1
vim.g.git_worktrees = {
  {
    toplevel = vim.env.HOME,
    gitdir = vim.env.HOME .. "/.dotfiles",
  },
}

-- Disabled
vim.g.loaded_python3_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
