local M = {}

function M.setup()
  local palette = require("gruvbox").palette

  local diffDelete        = "#4c1610"
  local diffDeleteChanged = "#6c1f17"
  local diffAdd           = "#31320a"
  local diffAddChanged    = "#494a0f"

  require("gruvbox").setup({
    contrast = "hard",
    overrides = {
        SignColumn     = { bg = palette.dark0_hard },
        GitSignsChange = { fg = palette.bright_aqua,  bg = nil },
        GitSignsAdd    = { fg = palette.bright_green, bg = nil },
        GitSignsDelete = { fg = palette.bright_red,   bg = nil },

        DiagnosticSignInfo  = { bg = palette.dark0_hard, fg = palette.bright_blue },
        DiagnosticSignWarn  = { bg = palette.dark0_hard, fg = palette.bright_yellow },
        DiagnosticSignHint  = { bg = palette.dark0_hard, fg = palette.bright_aqua },
        DiagnosticSignError = { bg = palette.dark0_hard, fg = palette.bright_red },

        DiffDelete     = { bg = diffDelete },
        DiffTextDelete = { bg = diffDeleteChanged },
        DiffAdd        = { bg = diffAdd },
        DiffChange     = { bg = diffAdd },
        DiffText       = { bg = diffAddChanged },

        FloatBorder = { link = "WinSeparator" }, -- Add fallback to pre-v0.10.0
    },
  })
  vim.cmd("colorscheme gruvbox")
end

return M
