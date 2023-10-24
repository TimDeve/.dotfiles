local utils = require("utils")
local v = require("utils.vim")

local M = {}

local auto_format_enabled = true

function M.format()
  require('conform').format({ lsp_fallback = true })
end

function M.auto_format()
  if auto_format_enabled then M.format() end
end

function M.auto_format_toggle()
  auto_format_enabled = not auto_format_enabled
end

function M.auto_format_buf_setup()
  v.autocmd({"BufWritePre"}, "<buffer>", M.auto_format)
  v.buf_command(0, "AutoFormatToggle", M.auto_format_toggle)
end

local function parse_gci_args()
  local args = {"write", "--skip-generated", "$FILENAME"}

  local config_file = vim.fs.find('.golangci.yml', { upward = true })[1]
  if not (config_file and utils.has_exe("yq")) then
    return args
  end

  local out = utils.capture_shell("yq '.linters-settings.gci' -o json " .. config_file)
  local gci_config = vim.json.decode(out)

  for _, section in ipairs(gci_config.sections) do
    table.insert(args, "-s")
    table.insert(args, section)
  end

  if gci_config["custom-order"] then
    table.insert(args, "--custom-order")
  end

  return args
end

function M.setup()
  local config = {
    formatters_by_ft = {
      go    = {},
      ["_"] = {"trim_newlines", "trim_whitespace"},
    },
    formatters = {},
  }

  if utils.has_exe("gci") then
    table.insert(config.formatters_by_ft.go, "gci")
    config.formatters.gci = { args = parse_gci_args() }
  end

  require("conform").setup(config)
end

return M
