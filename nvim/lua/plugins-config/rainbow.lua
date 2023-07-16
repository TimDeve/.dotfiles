local utils = require("utils")

local M = {}

function M.setup()
  utils.autocmd("FileType", {"clojure", "carp"}, "call rainbow_main#load()")
end

return M

