local blink = require('blink.cmp')

local opts = {

	appearance = {
		nerd_font_variant = "mono",
	},

	completion = {
		documentation = {
			auto_show = true,
			auto_show_delay_ms = 250,
			treesitter_highlighting = true,
		},
	},

	keymap = {
		["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
		["<CR>"] = { "accept", "fallback" },

		["<Up>"] = { "select_prev", "fallback" },
		["<Down>"] = { "select_next", "fallback" },
		["<C-up>"] = { "scroll_documentation_up", "fallback" },
		["<C-down>"] = { "scroll_documentation_down", "fallback" },
	},

	signature = {
		enabled = true,
	},

}

blink.setup(opts)
