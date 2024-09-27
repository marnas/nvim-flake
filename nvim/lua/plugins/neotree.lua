-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.api.nvim_set_keymap("n", "<leader>e", ":Neotree reveal toggle<cr>", {})

require("neo-tree").setup({
	close_if_last_window = true,
	hijack_unnamed_buffer_when_opening = true,
	filesystem = {
		use_libuv_file_watcher = true,
		follow_current_file = true,
		filtered_items = {
			visible = true,
			hide_dotfiles = false,
			hide_gitignored = false,
		},
	},
})

-- enable Neotree auto refresh after git commands
require("neo-tree.sources.filesystem.commands")
.refresh(
    require("neo-tree.sources.manager")
        .get_state("filesystem")
)
