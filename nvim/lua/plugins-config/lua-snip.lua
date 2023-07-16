local M = {}

function M.setup()
  require("luasnip.loaders.from_snipmate").lazy_load()
  vim.cmd [[
    snoremap <silent> <Tab> <cmd>lua require('luasnip').jump(1)<CR>
    snoremap <silent> <S-Tab> <cmd>lua require('luasnip').jump(-1)<CR>
  ]]
end

return M

