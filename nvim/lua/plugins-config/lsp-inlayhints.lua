local M = {}

function M.setup()
  require("lsp-inlayhints").setup({
    inlay_hints = {
      -- only_current_line = true,
      highlight = "Comment", -- highlight group
    },
    enabled_at_startup = true,
    debug_mode = false,
  })
end

return M
