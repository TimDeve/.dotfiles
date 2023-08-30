local M = {}

M.opts = {
 pre_save = function()
   -- Close Neotree to avoid empty buffer on restore
   vim.cmd [[ Neotree close ]]
 end
}

return M
