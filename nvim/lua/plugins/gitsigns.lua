-- Only non-default options; everything else uses gitsigns defaults.
require('gitsigns').setup {
	signs = {
		add          = { text = '┃' },
		change       = { text = '┃' },
		delete       = { text = '_' },
		topdelete    = { text = '‾' },
		changedelete = { text = '~' },
		untracked    = { text = '┆' },
	},
	attach_to_untracked          = true,
	current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
	preview_config               = { border = 'single' },
}
