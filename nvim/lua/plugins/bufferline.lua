require("bufferline").setup({
	options = {
		offsets = {
			{
				filetype = "neo-tree",
				text = "",
				highlight = "NeoTreeNormal",
				separator = false,
			},
		},
		show_buffer_close_icons = false,
		show_close_icon = false,
		separator_style = "thin",
	},
})

vim.keymap.set("n", "<C-q>", ":%bdelete|edit#|bdelete#<CR>", { desc = "Close all unfocused buffers" })
vim.keymap.set("n", "<C-w>", ":bp<CR>:bd#<CR>", { nowait = true, desc = "Close focused buffer" })
vim.keymap.set("n", "<leader>bl", ":BufferLineMoveNext<CR>", { desc = "Move buffer right" })
vim.keymap.set("n", "<leader>bh", ":BufferLineMovePrev<CR>", { desc = "Move buffer left" })
