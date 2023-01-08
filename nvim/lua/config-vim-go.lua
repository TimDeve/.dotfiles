local M = {}

M.ft = {"go", "gosum", "gowork", "gohtmltmpl"}

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

  require("which-key").register({
    ["<leader>li"] = { cmd_cb("call go#implements#Implements(-1)"), "Go to implementation [Go] " },
    ["<leader>lf"] = { cmd_cb("call go#fmt#Format(1)"), "Format [Go] " },
    ["<leader>lb"] = { "<Plug>(go-referrers)", "Find references [Go] " },
  })
end

return M
