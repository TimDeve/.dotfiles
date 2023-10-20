local utils = require("utils")
local augroup = require("utils.vim").augroup

local M = {}

function M.format()
  require('conform').format({ lsp_fallback = true })
end

function M.setup()
  local config = {
    formatters_by_ft = {
      go = {},
      sh = {"shfmt"},
    },
  }

  if utils.has_exe("gci") then
    table.insert(config.formatters_by_ft.go, "gci")

    local config_file = vim.fs.find('.golangci.yml', { upward = true })[1]
    if config_file and utils.has_exe("yq") then
      local out = vim.api.nvim_exec(":! yq '.linters-settings.gci.sections[]' -r " .. config_file , true)
      local lines = utils.lines(out)
      for i, line in ipairs(lines) do
        if i ~= 1 then -- Skip command echo
          table.insert(require("conform.formatters.gci").args, "-s")
          table.insert(require("conform.formatters.gci").args, line)
        end
      end
    end
  end

  augroup("format-on-save", {"BufWritePre"}, {"*.go", "*.rs"}, M.format)

  require("conform").setup(config)
end

return M

