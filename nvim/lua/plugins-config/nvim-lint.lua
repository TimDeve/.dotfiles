local utils = require("utils")

local M = {}

function M.setup()
  local linters = {
    sh = {'shellcheck'}
  }

  if utils.IS_WORK_MACHINE then
    M.arc_lint()
    M.errcheck()
    linters.go = {"arc_lint", "errcheck"}
  end

  require('lint').linters_by_ft = linters

  utils.autocmd("Filetype", "sh", function()
    utils.autocmd({"BufEnter", "TextChanged", "InsertLeave"}, "*", function() require("lint").try_lint() end)
  end)

  utils.autocmd({"BufEnter", "BufWritePost"}, "*", function() require("lint").try_lint() end)
end

function M.arc_lint()
  local severities = {
    info = vim.lsp.protocol.DiagnosticSeverity.Info,
    hint = vim.lsp.protocol.DiagnosticSeverity.Hint,
    error = vim.lsp.protocol.DiagnosticSeverity.Error,
    warning = vim.lsp.protocol.DiagnosticSeverity.Warning,
  }

  require('lint').linters.arc_lint = {
    cmd = 'arc',
    stdin = false,
    append_fname = true,
    args = {"lint", "--never-apply-patches", "--output", "json"},
    stream = "stdout",
    ignore_exitcode = true,
    parser = function(output, bufNo)
      if output == "" then return {} end

      -- Output is jsonl so we split on newlines
      local lines = utils.lines(output)
      if #lines < 1 then return {} end

      -- We're just hoping that the first diag is the file we ask for.
      -- Why arc lint returns files I didn't ask for is a mystery...
      local decoded = vim.json.decode(lines[1])
      local diagnostics = {}

      for filename, diag_list in pairs(decoded or {}) do
        for _, item in ipairs(diag_list or {}) do
          if item.severity ~= "autofix" then
            table.insert(diagnostics, {
              lnum = item.line - 1,
              col = item.char - 1,
              end_lnum = item.line - 1,
              end_col = item.char - 1,
              code = item.code,
              source = "arc-lint",
              user_data = {
                lsp = {
                  code = item.code,
                },
              },
              severity = assert(severities[item.severity], 'missing mapping for severity ' .. item.severity),
              message = "[" .. item.name .. "] " .. item.description,
            })
          end
        end
      end
      return diagnostics
    end
  }
end

function M.errcheck()
  require('lint').linters.errcheck = {
    cmd = 'errcheck',
    stdin = false,
    append_fname = false,
    args = {
      "-ignoretests",
      "-abspath",
      function() return vim.fn.expand("%:h") end
    },
    stream = "stdout",
    ignore_exitcode = true,
    parser = function(output, bufNo)
      local diagnostics = {}

      if output == "" then return {} end

      local lines = utils.lines(output)

      for _, line in ipairs(lines or {}) do
        local i, _, filename, row, end_col, indent, tail = string.find(line, "(.+):(%d+):(%d+):(%s*)(.*)")
        if i ~= nil then
          table.insert(diagnostics, {
            lnum     = row - 1,
            col      = 0,
            end_lnum = row - 1,
            end_col  = 0,
            source   = "errcheck",
            message  = "[errcheck] error return is ignored",
            severity = vim.lsp.protocol.DiagnosticSeverity.Warning,
          })
        end
      end

      return diagnostics
    end
  }
end

return M
