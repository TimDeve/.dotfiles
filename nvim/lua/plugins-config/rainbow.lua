local utils = require("utils")

local M = {}

function M.setup()
  utils.augroup("rainbow-load", "FileType", {"carp"}, "call rainbow_main#load()")
end

return M

