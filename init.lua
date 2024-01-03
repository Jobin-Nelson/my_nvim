local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system {
		'git',
		'clone',
		'--filter=blob:none',
		'https://github.com/folke/lazy.nvim.git',
		'--branch=stable', -- latest stable release
		lazypath,
	}
end
vim.opt.rtp:prepend(lazypath)

require('jobin.config')

require('lazy').setup({
  { import = 'jobin.plugins'},
}, {
  install = {
    colorscheme = {'catppuccin', 'habamax'},
  },
  change_detection = {
    enabled = true,
    notify = false,
  },
  checker = {
    enabled = true,
    notify = false,
  },
	defaults = {
		lazy = true,
	},
  ui = {
    border = 'rounded',
  },
	performance = {
		rtp = {
			disabled_plugins = {
				"gzip",
				"matchit",
				-- "matchparen",
				"netrwPlugin",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			}
		}
	}
})


