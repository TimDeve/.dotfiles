local command = require("utils.vim").command

command("SkipAllTests", function()
  vim.cmd [[
    :%s/t.Run.*/\0t.Skip("TODO REMOVE ME") \/\/ TODO(timdeve): Remove me before commit /ge
    :%s/s.Run.*/\0s.T().Skip("TODO REMOVE ME") \/\/ TODO(timdeve): Remove me before commit /ge
    :%s/func Test.*/\0t.Skip("TODO REMOVE ME") \/\/ TODO(timdeve): Remove me before commit /ge
  ]]
end)

command("SkipNoTests", function()
  vim.cmd [[
    :%s/t.Skip("TODO REMOVE ME").*\n//ge
    :%s/s.Skip("TODO REMOVE ME").*\n//ge
    :%s/s.T().Skip("TODO REMOVE ME").*\n//ge
  ]]
end)
