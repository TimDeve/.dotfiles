local cmd_cb = require("utils").cmd_cb
local buf_command = require("utils.vim").buf_command

require("plugins-config.conform").auto_format_buf_setup()

buf_command(0, "SkipAllTests", cmd_cb [[
  :%s/t.Run.*/\0t.Skip("TODO REMOVE ME") \/\/ TODO(timdeve): Remove me before commit /ge
  :%s/s.Run.*/\0s.T().Skip("TODO REMOVE ME") \/\/ TODO(timdeve): Remove me before commit /ge
  :%s/func Test.*/\0t.Skip("TODO REMOVE ME") \/\/ TODO(timdeve): Remove me before commit /ge
]])

buf_command(0, "SkipNoTests", cmd_cb [[
  :%s/t.Skip("TODO REMOVE ME").*\n//ge
  :%s/s.Skip("TODO REMOVE ME").*\n//ge
  :%s/s.T().Skip("TODO REMOVE ME").*\n//ge
]])
