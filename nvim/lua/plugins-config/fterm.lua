local M = {}

function M.setup()
  vim.cmd [[ :tnoremap <C-k> <C-\><C-n>:q<CR> ]]
end

return M

