local M = {}

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

M.diag_signs = { Error = "✖", Warn = "◼", Hint = "●", Info = "✱" }

return M
