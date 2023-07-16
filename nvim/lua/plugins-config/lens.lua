local M = {}

function M.setup()
  vim.cmd [[
    let g:lens#disabled = 1
    let g:lens#width_resize_min = 40
    let g:lens#disabled_filetypes = ['neo-tree']
    let g:animate#duration = 120.0
  ]]
end

return M
