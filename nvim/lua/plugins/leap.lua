-- Sneak-style mappings (recommended replacement for deprecated create_default_mappings)
vim.keymap.set({'n', 'x', 'o'}, 's',  '<Plug>(leap-forward)')
vim.keymap.set({'n', 'x', 'o'}, 'S',  '<Plug>(leap-backward)')
vim.keymap.set('n',             'gs', '<Plug>(leap-from-window)')
