local M = {}

function M.setup()
  vim.cmd [[
    augroup direnv-allow
      autocmd! * <buffer>
      autocmd BufWritePost <buffer> silent ! cd %:h && direnv allow
    augroup END
  ]]
end

return M
