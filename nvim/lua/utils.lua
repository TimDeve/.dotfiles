local utils_vim = require("utils.vim")

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

function M.config_setup(module)
  return function() require("plugins-config." .. module).setup() end
end

function M.config_cmd(module)
  return require("plugins-config." .. module).cmd
end

function M.config_opts(module)
  return require("plugins-config." .. module).opts
end

function M.config_keys(module)
  return require("plugins-config." .. module).keys
end

function M.merge(t1, t2)
  local new_table = {}
  if t1 ~= nil then
    for k,v in pairs(t1) do new_table[k] = v end
  end
  if t2 ~= nil then
    for k,v in pairs(t2) do new_table[k] = v end
  end
  return new_table
end

function M.flat_pretty_print(thing)
  local flat = string.gsub(vim.inspect(thing), "\n", "")
  print(flat)
end

function M.trigger_code_action(title)
  vim.lsp.buf.code_action({
    context = { only = { title } },
    apply = true
  })
end

function M.truthy(v)
  if     type(v) == "number"  then return v ~= 0
  elseif type(v) == "boolean" then return v
  end

  return false
end

function M.cmd_cb(c) return function() vim.cmd(c) end end

function M.capture_shell(command)
  local cmd_out = vim.api.nvim_exec(":! " .. command, true)
  local exit_code = vim.v.shell_error

  local lines = M.lines(cmd_out)
  table.remove(lines, 1)

  return table.concat(lines, "\n"), exit_code
end

function M.project_files(opts)
  vim.fn.system('git rev-parse --is-inside-work-tree')
  if vim.v.shell_error == 0 then
    require"telescope.builtin".git_files(opts)
  else
    require"telescope.builtin".find_files(opts)
  end
end

function M.match_filetype(matches)
  for _, match in ipairs(matches) do
    utils_vim.augroup("filetype-" .. match[2], {"BufRead", "BufNewFile"}, match[1], "setlocal filetype=" .. match[2])
  end
end

function M.lines(str)
  local result = {}
  for line in str:gmatch '[^\n]+' do
    table.insert(result, line)
  end
  return result
end

function M.enabled_if_env(env)
  return function()
    return os.getenv(env) ~= nil
  end
end

function M.enabled_if_exe(exe)
  return function()
    return M.has_exe(exe)
  end
end

function M.repo_root()
  local cwd = vim.fn.getcwd()
  local git_folder = vim.fs.find('.git', { upward = true, path = cwd })[1]
  return vim.fs.dirname(git_folder)
end

M.signs = {
  cross             = "✖",
  inverted_triangle = "▼",
  circle            = "●",
  square            = "◼",
  diamond           = "◆",
  check             = "✓",
}

M.diag_signs = {
  Error = M.signs.cross,
  Warn = M.signs.inverted_triangle,
  Hint = M.signs.circle,
  Info = M.signs.square,
  Other = M.signs.diamond,
}
M.diag_signs.error       = M.diag_signs.Error
M.diag_signs.warn        = M.diag_signs.Warn
M.diag_signs.warning     = M.diag_signs.Warn
M.diag_signs.hint        = M.diag_signs.Hint
M.diag_signs.info        = M.diag_signs.Info
M.diag_signs.information = M.diag_signs.Info
M.diag_signs.other       = M.diag_signs.Other

M.lisp_ft = {"clojure", "scheme", "carp"}

return M
