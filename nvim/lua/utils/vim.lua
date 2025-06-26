local M = {}

function M.augroup(group, events, pattern, command)
  if group ~= nil then
    vim.api.nvim_create_augroup(group, { clear = false })
    vim.api.nvim_clear_autocmds({ group = group, pattern = pattern })
  end

  local opts = {
    pattern = pattern,
    group = group,
  }

  if type(command) == "function" then
    opts.callback = command
  else
    opts.command = command
  end

  vim.api.nvim_create_autocmd(events, opts)
end

function M.autocmd(events, pattern, command)
  M.augroup(nil, events, pattern, command)
end

function M.command(cmd_name, cmd, attrs)
  vim.api.nvim_create_user_command(cmd_name, cmd, attrs or {})
end

function M.buf_command(buffer, cmd_name, cmd, attrs)
  vim.api.nvim_buf_create_user_command(buffer, cmd_name, cmd, attrs or {})
end

function M.highlight(name, val)
  vim.api.nvim_set_hl(0, name, val)
end

function M.sign_define(name, opts)
  local signs = {}
  for k, v in pairs(opts) do
    signs[k] = { [name] = v }
  end
  vim.diagnostic.config({signs = signs})
end

return M
