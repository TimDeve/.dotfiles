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
    M.setup_revive_custom()
    table.insert(linters.go, "revive_custom")

    M.setup_golangci_custom()
    table.insert(linters.go, "golangcilint_custom")

    -- M.setup_arc_lint()
    -- table.insert(linters.go, "arc_lint")
    -- table.insert(linters.markdown, "arc_lint")
  end

  require('lint').linters_by_ft = linters

 augroup("shellcheck-lint-filetype", "Filetype", "sh", function()
   augroup("shellcheck-lint-on-change", {"TextChanged", "InsertLeave"}, "<buffer>", function() require("lint").try_lint() end)
 end)

 autocmd({"BufRead", "BufWritePost"}, "*", function() require("lint").try_lint() end)
end

function M.setup_golangci_custom()
  local golangci = require('lint').linters.golangcilint

  local args = utils.concat(golangci.args, {"-D","revive"})

  require('lint').linters.golangcilint_custom = utils.merge(golangci, {args = args})
end

function M.setup_revive_custom()
  local fast_lint = true
  local filename_mod = ""

  if fast_lint ~= true then
    filename_mod = ":h"
  end

  local function parse_revive_rules()
    local config_str = ""

    local config_file = vim.fs.find('.golangci.yml', { upward = true })[1]
    if not (config_file and utils.has_exe("yq")) then
      return config_str
    end

    local revive_rules_json = utils.capture_shell("yq '[.linters.settings.revive.rules[].name]' -o json " .. config_file)
    local revive_rules = vim.json.decode(revive_rules_json)

    for _, rule in ipairs(revive_rules) do
      -- Skipping package-comments because it gives false positive when linting
      -- individual files.
      if not fast_lint or rule ~= "package-comments" then
        config_str = config_str .. "[rule." .. rule .. "]\n"
      end
    end

    return config_str
  end

  require('lint').linters.revive_custom = {
    cmd = "bash",
    append_fname = false,
    args = {
      "-c",
      'config="$1"; shift; revive -config <(echo -e "$config") -formatter json "$@"',
      "revive_custom",
      parse_revive_rules,
      function()
        return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), filename_mod)
      end
    },
    stdin = require('lint').linters.revive.stdin,
    parser = require('lint').linters.revive.parser,
  }
end

function M.setup_arc_lint()
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
              if item.severity ~= "autofix" and item.name ~= "revive" then
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

function M.setup_errcheck()
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
