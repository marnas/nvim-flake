-- tokyonight-night — comprehensive treesitter coverage with codescope-like
-- vibrancy. transparent = true lets terminal black show through.
require("tokyonight").setup({
  style = "night", -- night | storm | moon | day
  transparent = true,
  styles = {
    comments = { italic = true },
    keywords = { italic = false },
    sidebars = "transparent",
    floats = "transparent",
  },
})

vim.cmd.colorscheme("tokyonight-night")
