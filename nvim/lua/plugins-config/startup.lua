local utils = require("utils")

local M = {}

function M.setup()
  -- NerdCommenter
  vim.g.NERDDefaultAlign = 'left'
  vim.g.NERDCommentEmptyLines = 1
  vim.g.NERDCreateDefaultMappings = 0
  vim.g.NERDSpaceDelims = 1
  vim.g.NERDCustomDelimiters = { carp = { left = ";" }, please = { left = "#" } }

  -- Disable sexp default for leader w
  vim.g.sexp_mappings = { sexp_round_head_wrap_element = "" }

  -- GitGutter
  vim.opt.updatetime = 250

  -- vim-move (Disable default bindings)
  vim.g.move_map_keys = 0

  -- vim-table-mode
  vim.g.table_mode_map_prefix = '<Leader>m'

  -- vim-todo
  vim.g.VimTodoListsMoveItems = 0

  -- Markdown
  vim.g.vim_markdown_folding_disabled = 1
  vim.g.vim_markdown_new_list_item_indent = 0
  vim.g.vim_markdown_frontmatter = 1

  -- Extra shebang detection
  vim.cmd [[
    AddShebangPattern! clojure ^#!.*/bin/env\s\+bb\>
    AddShebangPattern! typescript ^#!.*/bin/env\s\+deno.*\>
    AddShebangPattern! typescript ^#!.*/bin/env\s-S\sdeno.*\>
  ]]

  -- vim-visual-multi
  vim.g["VM_set_statusline"] = 0 -- Disable status line, use lualine instead
  vim.g["VM_silent_exit"] = 1
  vim.g["VM_show_warnings"] = 0


  -- Postgres bindings
  vim.g["sql_type_default"] = 'pgsql'
end

return M
