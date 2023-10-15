local utils = require("utils")

local M = {}

function M.setup()
  utils.augroup("todo-init", "FileType", {"todo"}, "call g:VimTodoListsInit()")
end

return M

