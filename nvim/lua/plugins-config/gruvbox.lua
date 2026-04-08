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

        NormalFloat = { bg = palette.dark0_soft, fg="none" },
        FloatTitle  = { bg = palette.bright_red, fg = palette.dark0, bold = true },
        FloatBorder = { fg = palette.dark0_soft, bg = palette.dark0_soft },

        Headline1 = { bg = "#253409", fg = palette.bright_green },
        Headline2 = { bg = "#32453d", fg = palette.bright_blue },
        Headline3 = { bg = "#355529", fg = palette.bright_aqua },
        Headline4 = { bg = "#6f3200", fg = palette.bright_orange },
        Headline5 = { bg = "#652536", fg = palette.bright_purple },

        ["@markup.strong"] = { fg = palette.neutral_purple },
        ["@text.emphasis"] = { fg = palette.neutral_yellow },

        -- FloatBorder = { link = "WinSeparator" }, -- Add fallback to pre-v0.10.0
    },
  })
  vim.cmd("colorscheme gruvbox")
end

return M
