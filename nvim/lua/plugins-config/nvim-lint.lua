local utils = require("utils")
local augroup = require("utils.vim").augroup
local autocmd = require("utils.vim").autocmd

local M = {}

function M.setup()
  local linters = {
    sh = {'shellcheck'},
    go = {},
    markdown = {},
  }

  -- Allows shellcheck to follow source
  local shellcheck_args = {"-x", "-P", function() return vim.fn.expand("%:h") end}
  for _, arg in ipairs(shellcheck_args) do
    table.insert(require('lint').linters.shellcheck.args, arg)
  end


  -- if utils.has_exe("errcheck") then
  --   M.errcheck()
  --   table.insert(linters.go, "errcheck")
  -- end

  if utils.has_exe("arc") then
    M.arc_lint()
    table.insert(linters.go, "arc_lint")
    table.insert(linters.markdown, "arc_lint")
  end

  require('lint').linters_by_ft = linters

 augroup("shellcheck-lint-filetype", "Filetype", "sh", function()
   augroup("shellcheck-lint-on-change", {"TextChanged", "InsertLeave"}, "<buffer>", function() require("lint").try_lint() end)
 end)

 autocmd({"BufRead", "BufWritePost"}, "*", function() require("lint").try_lint() end)
end

function M.arc_lint()
  local severities = {
    info = vim.lsp.protocol.DiagnosticSeverity.Info,
    advice = vim.lsp.protocol.DiagnosticSeverity.Info,
    hint = vim.lsp.protocol.DiagnosticSeverity.Hint,
    error = vim.lsp.protocol.DiagnosticSeverity.Error,
    warning = vim.lsp.protocol.DiagnosticSeverity.Warning,
  }

  require('lint').linters.arc_lint = {
    cmd = '/usr/bin/env',
    stdin = false,
    append_fname = true,
    args = {
      "sh",
      "-c",
      function()
        local shims    = "PATH=$HOME/.shims:$PATH " -- Shims will skip linters I don't care for
        local command  = "arc lint --never-apply-patches --output json"
        local filepath = "'" .. vim.fn.expand("%") .. "'"
        local job      =  "& pid=$! && wait $pid"
        return table.concat({shims, command, filepath, job}, " ")
      end
    },
    stream = "stdout",
    ignore_exitcode = true,
    parser = function(output, bufNo)
      -- Output is jsonl so we split on newlines
      local lines = utils.lines(output)
      if #lines < 1 then return {} end

      local buf_filepath = vim.api.nvim_buf_get_name(bufNo)
      local diagnostics = {}

      for _, line in ipairs(lines) do
        local decoded = vim.json.decode(line)
        for filepath, diag_list in pairs(decoded or {}) do
          if string.find(buf_filepath, filepath) then
            for _, item in ipairs(diag_list or {}) do
              if item.severity ~= "autofix" then
                local char = utils.truthy(item.char) and item.char or 0
                table.insert(diagnostics, {
                  lnum = item.line - 1,
                  col = char - 1,
                  end_lnum = item.line - 1,
                  end_col = char - 1,
                  code = item.code,
                  source = "arc-lint",
                  user_data = {
                    lsp = {
                      code = item.code,
                    },
                  },
                  severity = severities[item.severity],
                  message = "[" .. item.name .. "] " .. item.description,
                })
              end
            end
            return diagnostics
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

      local buf_filepath = vim.api.nvim_buf_get_name(bufNo)
      local lines = utils.lines(output)

      for _, line in ipairs(lines or {}) do
        local i, _, filepath, row, end_col, indent, tail = string.find(line, "(.+):(%d+):(%d+):(%s*)(.*)")
        if i ~= nil and filepath == buf_filepath then
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
