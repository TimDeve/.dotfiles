local M = {}

function M.setup_arc_lint()
  local null_ls = require("null-ls")
  local h = require("null-ls.helpers")
  local methods = require("null-ls.methods")
  local u = require("null-ls.utils")

  local severities = {
      info = vim.lsp.protocol.DiagnosticSeverity.Info,
      hint = vim.lsp.protocol.DiagnosticSeverity.Hint,
      error = vim.lsp.protocol.DiagnosticSeverity.Error,
      warning = vim.lsp.protocol.DiagnosticSeverity.Warning,
  }

  local arc_lint = {
      name = "arc-lint",
      method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
      filetypes = { "go" },
      generator = null_ls.generator({
          command = "arc",
          args = {
            "lint",
            "--output",
            "json",
            "$FILENAME",
          },
          to_stdin = false,
          from_stderr = false,
          ignore_stderr = false,
          format = "json_raw",
          timeout = 3000, -- 3 seconds, arc lint is real slow
          multiple_files = true, -- TODO: Shouldn't be multiple files, figure out a way to filter...
          check_exit_code = function(code) return true end,
          on_output = function(params)
              local diags = {}

              -- Clear diagnostics if arc lint fails to send any
              if params.err ~= nil then
                return {}
              end

              for filename, diag_list in pairs(params.output) do
                for _, d in ipairs(diag_list) do
                  if d.severity ~= "autofix" then
                    local filename = u.path.join(params.root, filename)
                    table.insert(diags, {
                        row = d.line,
                        col = d.char,
                        end_row = d.line,
                        end_col = d.char,
                        source = "arc-lint",
                        message = "[" .. d.code .. "] " .. d.name .. ": " .. d.description,
                        severity = severities[d.Severity],
                        filename = filename,
                    })
                  end
                end
              end
              return diags
          end,
      }),
  }
  null_ls.register(arc_lint)
end

function M.setup_errcheck()
  local null_ls = require("null-ls")
  local h = require("null-ls.helpers")
  local methods = require("null-ls.methods")
  local u = require("null-ls.utils")

  local errcheck = {
      name = "errcheck",
      method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
      filetypes = { "go" },
      generator = null_ls.generator({
          command = "errcheck",
          args = {
            "-ignoretests",
            "-abspath",
            "$DIRNAME",
          },
          to_stdin = false,
          from_stderr = false,
          ignore_stderr = true,
          format = "line",
          timeout = 5000, -- 5 seconds, errcheck is real slow
          multiple_files = true,
          check_exit_code = function(code) return true end,
          on_output = function(line)
              local diags = {}

              local i, _, filename, row, end_col, indent, tail = string.find(line, "(.+):(%d+):(%d+):(%s*)(.*)")
              if i ~= nil then
                return {
                    row      = row,
                    --col      = end_col,
                    end_row  = row,
                    --end_col  = end_col,
                    source   = "errcheck",
                    message  = "[errcheck] error return is ignored",
                    severity = vim.lsp.protocol.DiagnosticSeverity.Warning,
                    filename = filename,
                }
              end

              return nil
          end,
      }),
  }
  null_ls.register(errcheck)
end

function M.setup(on_lsp_attach)
  local null_ls = require("null-ls")
  local utils = require("utils")

  if utils.IS_WORK_MACHINE then
    M.setup_arc_lint()
    M.setup_errcheck()
  end

  null_ls.setup({
    sources = {
      null_ls.builtins.diagnostics.shellcheck,
      null_ls.builtins.code_actions.shellcheck,
    },
    on_attach = on_lsp_attach,
  })
end

return M
