local M = {}

M.keys = {"s", "S"}

function M.setup()
  require('leap').set_default_keymaps()
end


return M
