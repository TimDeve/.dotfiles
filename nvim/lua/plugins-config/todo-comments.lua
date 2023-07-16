local utils = require("utils")

local M = {}

function M.setup()
  local todo = require("todo-comments")

  todo.setup {
    signs = false,
    keywords = {
      FIX =  { icon = utils.signs.inverted_triangle },
      TODO = { icon = utils.signs.check },
      HACK = { icon = utils.signs.inverted_triangle },
      WARN = { icon = utils.signs.inverted_triangle },
      PERF = { icon = utils.signs.diamond },
      NOTE = { icon = utils.signs.circle },
      TEST = { icon = utils.signs.circle },
    },
    highlight = {
      keyword = "fg",
      after = "fg",
      pattern = [[.*<(KEYWORDS)(\([^\)]*\))?:]],
    },
    search = {
      pattern = [[\b(KEYWORDS)(\([^\)]*\))?:]],
    },
  }

  require("which-key").register({
    ["]t"] = { todo.jump_next, "Next todo"},
    ["[t"] = { todo.jump_prev, "Previous todo"},
  })
end

return M
