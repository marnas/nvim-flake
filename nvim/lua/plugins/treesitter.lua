-- Treesitter highlighting (parsers managed by Nix)
vim.api.nvim_create_autocmd('FileType', {
	callback = function()
		pcall(vim.treesitter.start)
	end,
})

-- Textobjects configuration
require('nvim-treesitter-textobjects').setup({
	select = { lookahead = true },
	move = { set_jumps = true },
})

-- Select keymaps
local select = require('nvim-treesitter-textobjects.select')
local function map_select(keys, query)
	vim.keymap.set({ 'x', 'o' }, keys, function()
		select.select_textobject(query, 'textobjects')
	end)
end

map_select('af', '@function.outer')
map_select('if', '@function.inner')
map_select('ac', '@class.outer')
map_select('ic', '@class.inner')
map_select('aa', '@parameter.outer')
map_select('ia', '@parameter.inner')

-- Move keymaps
local move = require('nvim-treesitter-textobjects.move')
local function map_move(keys, fn, query)
	vim.keymap.set({ 'n', 'x', 'o' }, keys, function()
		fn(query, 'textobjects')
	end)
end

map_move(']m', move.goto_next_start, '@function.outer')
map_move('[m', move.goto_previous_start, '@function.outer')
map_move(']M', move.goto_next_end, '@function.outer')
map_move('[M', move.goto_previous_end, '@function.outer')
map_move(']]', move.goto_next_start, '@class.outer')
map_move('[[', move.goto_previous_start, '@class.outer')
map_move('][', move.goto_next_end, '@class.outer')
map_move('[]', move.goto_previous_end, '@class.outer')
