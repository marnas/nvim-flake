local opts = { noremap = true, silent = true }

-- Shorten function name
local remap = vim.api.nvim_set_keymap

--Remap space as leader key
remap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Normal --
-- Window navigation (<C-h/j/k/l>) is provided by vim-tmux-navigator's own mappings

-- Resize with arrows
remap("n", "<C-Up>", ":resize +2<CR>", opts)
remap("n", "<C-Down>", ":resize -2<CR>", opts)
remap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
remap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Navigate buffers
-- These unicode characters have been mapped to ctrl-tab and ctrl-shift-tab
remap("n", "⌐", ":bnext<CR>", opts)
remap("n", "¬", ":bprevious<CR>", opts)

-- Better Scrolling
-- remap("n", "<C-N>", "<C-E>", opts)
-- remap("n", "<C-E>", "<C-Y>", opts)

-- Go to first character
remap("n", "0", "^", opts)

-- Clear search highlights
remap("n", "\\\\", ":nohlsearch<CR>", opts)

remap('t', '<esc>', [[<C-\><C-n>]], opts)

-- Visual --
-- Stay in indent mode
remap("v", "<S-h>", "<gv", opts)
remap("v", "<S-l>", ">gv", opts)

-- Don't yank after pasting
remap("v", "p", '"_dP', opts)

-- Diagnostic keymaps ([d / ]d are built-in defaults since 0.10)
vim.keymap.set("n", "<leader>f", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })
