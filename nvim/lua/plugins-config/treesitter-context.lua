local M = {}

function M.setup()
  require('treesitter-context').setup({
    patterns = {
      go = {
        'function_declaration',
      },
    },
  })
end

return M
