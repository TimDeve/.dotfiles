local utils = require("utils")

local M = {}

function M.bindings()
  require("which-key").register({
    ["<leader>lg"] = {
      name = "Go Guru",
      i = { "<Cmd>Lazy load vim-go | call go#implements#Implements(-1)<CR>", "Go to implementation"  },
      f = { "<Cmd>Lazy load vim-go | call go#fmt#Format(1)<CR>",             "Format" },
      b = { "<Cmd>Lazy load vim-go | call go#referrers#Referrers(-1)<CR>",   "Find references" },
    }
  })
end

function M.setup()
  vim.g.go_def_mapping_enabled    = false
  vim.g.go_doc_keywordprg_enabled = false
  vim.g.go_textobj_enabled        = false
  vim.g.go_gopls_enabled          = false
  vim.g.go_info_mode              = "guru"
  vim.g.go_def_mode               = "godef"
  vim.g.go_referrers_mode         = "guru"
  vim.g.go_implements_mode        = "guru"
  vim.g.go_fmt_command            = "goimports"
end

return M
