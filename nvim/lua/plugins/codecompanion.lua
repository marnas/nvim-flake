require("codecompanion").setup({
	strategies = {
		chat = {
			adapter = "copilot",
		},
		inline = {
			adapter = "copilot",
		},
	},
	-- adapters = {
	-- 	copilot = function()
	-- 		return require("codecompanion.adapters").extend("copilot", {
	-- 			env = {
	-- 				api_key = "cmd:op read op://personal/OpenAI/credential --no-newline",
	-- 			},
	-- 		})
	-- 	end,
	-- },
})

vim.api.nvim_set_keymap('n', '<leader>cc', ':CodeCompanion', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>ch', ':CodeCompanionChat<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>ca', ':CodeCompanionActions<CR>', { noremap = true, silent = true })
