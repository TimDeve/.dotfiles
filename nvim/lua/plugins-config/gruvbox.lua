local M = {}

local contrast = "hard"

function M.setup()
  local palette = require("gruvbox").palette

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
    },
  })
  vim.cmd("colorscheme gruvbox")
end

return M

