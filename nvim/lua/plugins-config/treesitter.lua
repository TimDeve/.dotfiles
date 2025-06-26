local utils = require("utils")

local M = {}

function M.setup()
  local treesitter_langs = {
    "bash", "c", "cpp", "go", "hcl", "javascript", "json", "jq", "lua",
    "proto", "python", "regex", "rust", "scheme", "sql",  "toml", "tsx",
    "typescript", "vim", "yaml"
  }
  local treesitter_enabled = { norg = true, norg_meta = true }
  for _, lang in ipairs(treesitter_langs) do
    treesitter_enabled[lang] = true
  end

  local treesitter_settings = {
    highlight = {
      enable = true,
      disable = function(lang) return treesitter_enabled[lang] ~= true end,
    },
  }

  if utils.has_exe("tree-sitter") then
    treesitter_settings.ensure_installed = treesitter_langs
  end

  require('nvim-treesitter.configs').setup(treesitter_settings)
end

return M
