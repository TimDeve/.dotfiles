local utils = require("utils")

local M = {}

function M.setup()
  utils.autocmd("FileType", {"todo"}, "call g:VimTodoListsInit()")
end

return M

