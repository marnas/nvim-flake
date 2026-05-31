-- mini.statusline + mini.tabline — matches the tmux-agent-indicator demo.
-- Author's config: https://github.com/accessd/dotfiles/blob/main/nvim/lua/kickstart/plugins/mini.lua

local statusline = require("mini.statusline")

statusline.setup({
  use_icons = true,
})

-- Override default `LINE/TOTAL_LINES│COL` with terse LINE:COL.
---@diagnostic disable-next-line: duplicate-set-field
statusline.section_location = function()
  return "%2l:%-2v"
end

-- Per-mode statusline chip colors. tokyonight-night palette.
local mode_highlights = {
  MiniStatuslineModeNormal  = { fg = "#1a1b26", bg = "#7AA2F7", bold = true }, -- blue
  MiniStatuslineModeInsert  = { fg = "#1a1b26", bg = "#9ECE6A", bold = true }, -- green
  MiniStatuslineModeVisual  = { fg = "#1a1b26", bg = "#BB9AF7", bold = true }, -- magenta
  MiniStatuslineModeReplace = { fg = "#1a1b26", bg = "#F7768E", bold = true }, -- red
  MiniStatuslineModeCommand = { fg = "#1a1b26", bg = "#E0AF68", bold = true }, -- yellow
  MiniStatuslineModeOther   = { fg = "#1a1b26", bg = "#7DCFFF", bold = true }, -- cyan
}
-- Re-apply after every colorscheme change so theme switches don't wipe them.
local function set_mode_highlights()
  for group, spec in pairs(mode_highlights) do
    vim.api.nvim_set_hl(0, group, spec)
  end
end
set_mode_highlights()
vim.api.nvim_create_autocmd("ColorScheme", { callback = set_mode_highlights })

-- mini.tabline replaced by bufferline.nvim (supports neo-tree offset)
