local M = {}

M.IS_WORK_MACHINE = os.getenv("IS_WORK_MACHINE") ~= nil
vim.g.IS_WORK_MACHINE = M.IS_WORK_MACHINE

function M.has_exe(exe)
  return vim.fn.executable(exe) == 1
end

function M.setup_all(modules)
  for _, mod in ipairs(modules) do
    require(mod).setup()
  end
end

function M.VimEnter_cb(cmd)
  return function() M.autocmd("VimEnter", "*", cmd) end
end

function M.setup_config_cb(module, opts)
  return function() require(module).setup(opts) end
end

function M.merge(t1, t2)
  local new_table = {}
  for k,v in pairs(t1) do new_table[k] = v end
  for k,v in pairs(t2) do new_table[k] = v end
  return new_table
end

function M.autocmd(events, pattern, command)
  local opts = { pattern = pattern }

  if type(command) == "function" then
    opts.callback = command
  else
    opts.command = command
  end

  vim.api.nvim_create_autocmd(events, opts)
end

function M.highlight(name, val)
  vim.api.nvim_set_hl(0, name, val)
end

function M.flat_pretty_print(thing)
  local flat = string.gsub(vim.inspect(thing), "\n", "")
  print(flat)
end

function M.trigger_code_action(title)
  vim.lsp.buf.code_action({
    filter = function(action) return action.title == title end,
    apply = true
  })
end

function M.truthy(v)
  if     type(v) == "number"  then return v ~= 0
  elseif type(v) == "boolean" then return v
  end

  return false
end

function M.cmd_cb(c)
  local cb = function() vim.cmd(c) end
  return cb
end

function M.match_filetype(matches)
  for _, match in ipairs(matches) do
    M.autocmd({"BufRead", "BufNewFile"}, match[1], "setlocal filetype=" .. match[2])
  end
end

M.diag_signs = { Error = "✖", Warn = "▼", Hint = "●", Info = "◼", Other = "◆" }
M.diag_signs.error       = M.diag_signs.Error
M.diag_signs.warn        = M.diag_signs.Warn
M.diag_signs.warning     = M.diag_signs.Warn
M.diag_signs.hint        = M.diag_signs.Hint
M.diag_signs.info        = M.diag_signs.Info
M.diag_signs.information = M.diag_signs.Info
M.diag_signs.other       = M.diag_signs.Other

return M
