vim.opt.termguicolors = true
vim.api.nvim_set_keymap("n", "<C-w>", ":bp <cr>:bd# <cr>", {})
vim.api.nvim_set_keymap("n", "<leader>bl", ":BufferLineMoveNext <cr>", {})
vim.api.nvim_set_keymap("n", "<leader>bh", ":BufferLineMovePrev <cr>", {})

require("bufferline").setup {
	options = {
		offsets = {
			{
				filetype = "neo-tree",
				text = "File Explorer"
				,
				text_align = "left"
			} },
		show_buffer_close_icons = false,
	}
}
