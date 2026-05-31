-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.api.nvim_set_keymap("n", "<leader>e", ":Neotree reveal toggle<cr>", {})

require("neo-tree").setup({
	close_if_last_window = true,
	-- hijack_unnamed_buffer_when_opening = true,
	filesystem = {
		use_libuv_file_watcher = true,
		follow_current_file = {
			enabled = true,
		},
		filtered_items = {
			visible = true,
			hide_dotfiles = false,
			hide_gitignored = false,
		},
	},
	hijack_netrw_behavior = "open_current", -- netrw disabled, opening a directory opens neo-tree
	-- in whatever position is specified in window.position
	-- "open_current",  -- netrw disabled, opening a directory opens within the
	use_libuv_file_watcher = true,
	-- show_unloaded = true,
	window = {
		mappings = {
			["P"] = { "toggle_preview", config = { use_float = false, use_image_nvim = true } },
		}
	},
})

vim.api.nvim_create_autocmd({ "FileType", "BufWinEnter", "WinEnter" }, {
	callback = function()
		if vim.bo.filetype == "neo-tree" then
			vim.schedule(function()
				vim.opt_local.statusline = " "
				vim.opt_local.fillchars = { eob = " " }
				vim.opt_local.winhighlight = "Normal:NeoTreeNormal,NormalNC:NeoTreeNormal,StatusLine:NeoTreeNormal,StatusLineNC:NeoTreeNormal,EndOfBuffer:NeoTreeNormal"
			end)
		end
	end,
})

-- Enabling git events for auto-refresh
local events = require("neo-tree.events")
events.fire_event(events.GIT_EVENT)

-- enable Neotree auto refresh after git commands
-- require("neo-tree.sources.filesystem.commands")
-- 		.refresh(
-- 			require("neo-tree.sources.manager")
-- 			.get_state("filesystem")
-- 		)
