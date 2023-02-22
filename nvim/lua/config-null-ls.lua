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
      method = null_ls.methods.DIAGNOSTICS,
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
          multiple_files = false,
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

function M.setup()
  local null_ls = require("null-ls")
  local utils = require("utils")

  if utils.IS_WORK_MACHINE then
    M.setup_arc_lint()
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
