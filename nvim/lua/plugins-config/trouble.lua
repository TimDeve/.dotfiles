local utils = require("utils")

local M = {}

M.opts = {
  icons = false,
  fold_open = "▼",
  fold_closed = "▶",
  indent_lines = false,
  use_diagnostic_signs = true,
  signs = utils.diag_signs,
}

return M

