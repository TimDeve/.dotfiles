local utils = require("utils")

local M = {}

function M.setup()
  local treesitter_langs = {
    "bash", "c", "cpp", "go", "hcl", "javascript", "json", "lua",
    "python","norg", "norg_meta", "regex", "rust", "scheme", "sql",  "toml",
    "tsx", "typescript", "vim", "yaml",
  }
  for _, lang in ipairs(treesitter_langs) do
    treesitter_langs[lang] = true
  end

  local treesitter_settings = {
    highlight = {
      enable = true,
      disable = function(lang) return treesitter_langs[lang] ~= true end,
    },
  }

  if utils.has_exe("tree-sitter") then
    treesitter_settings.ensure_installed = treesitter_langs
  end

  require('nvim-treesitter.configs').setup(treesitter_settings)
end

return M

