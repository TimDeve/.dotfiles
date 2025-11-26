local autocmd = require("utils.vim").autocmd

local M = {}

function M.setup()
  require("persistence").setup()

  -- Close Neotree as it would be broken on restore
  autocmd({"User"}, "PersistenceSavePre", function() vim.cmd [[ Neotree close ]] end)
end

return M
