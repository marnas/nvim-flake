local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Install your plugins here
local plugins = {
	-- "christoomey/vim-tmux-navigator",
	{
		"numToStr/Navigator.nvim",
		config = function() require('Navigator').setup({ disable_on_zoom = true }) end
	},

	{
		"windwp/nvim-autopairs",
		config = function() require("nvim-autopairs").setup {} end
	},
}

local opts = {}

require("lazy").setup(plugins, opts)