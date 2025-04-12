vim.opt.showmode = false
vim.opt.hlsearch = false
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = false
vim.opt.mouse = 'a'
-- only set clipboard if not in ssh, to make sure the OSC 52
-- integration works automatically. Requires Neovim >= 0.10.0
-- https://github.com/neovim/neovim/commit/a389dc2f950ef89492dfc2d8334e421d2252cddf/
vim.opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus" -- Sync with system clipboard
vim.opt.list = true
vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.breakindentopt = 'list:2,min:20,sbr'
vim.opt.smoothscroll = true
-- vim.opt.showbreak = '↪ '
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = 'yes'
vim.opt.backup = false
vim.opt.updatecount = 0
vim.opt.completeopt = 'menu,menuone,noinsert,noselect,popup'
vim.opt.termguicolors = true
vim.opt.conceallevel = 2
vim.opt.signcolumn = 'yes'
vim.opt.laststatus = 3
-- vim.opt.statuscolumn = '%=%C%s%{v:relnum?v:relnum:v:lnum } '

-- Folding
vim.opt.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}
vim.opt.foldenable = false
vim.opt.foldlevelstart = 99
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldtext = "v:lua.CustomFoldText()"
function CustomFoldText()
  local line = vim.fn.getline(vim.v.foldstart)
  local line_count = vim.v.foldend - vim.v.foldstart + 1
  local line_count_text = ("│ %4d lines │"):format(line_count)
  local win_width = vim.api.nvim_win_get_width(0)
  local foldtext_start = (" " .. line):sub(1, math.floor(win_width * 2) / 3)
  local foldtext_end = line_count_text .. ("."):rep(10)
  local foldtext_length = vim.fn.strchars(foldtext_start .. foldtext_end)
  return foldtext_start .. ("."):rep(win_width - foldtext_length) .. foldtext_end
end

vim.opt.winbar = '%=%m %t'
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Indent
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true

vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.wrap = false
vim.opt.incsearch = true
vim.opt.undodir = vim.fn.stdpath('config') .. '/undodir'
vim.opt.undofile = true
vim.opt.swapfile = false
vim.opt.pumheight = 10
vim.opt.pumblend = 0
vim.opt.virtualedit = 'block'
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
