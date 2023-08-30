local M = {}

function M.dapui()
  require("dapui").setup {
    icons = { expanded = "▼", collapsed = "▶", current_frame = "○" },
    controls = {
      icons = {
        pause = "⏸",
        play = "⏵",
        step_into = "↳",
        step_over = "↷",
        step_out = "↰",
        step_back = "↤",
        run_last = "↺",
        terminate = "✖",
        disconnect = "⏹",
      },
    },
  }
end

function M.setup()
  vim.fn.sign_define("DapBreakpoint",          {text='●', texthl='DiagnosticSignError', linehl='', numhl=''})
  vim.fn.sign_define("DapBreakpointCondition", {text='○', texthl='DiagnosticSignError', linehl='', numhl=''})
  vim.fn.sign_define("DapLogPoint",            {text='◆', texthl='DiagnosticSignInfo',  linehl='', numhl=''})
  vim.fn.sign_define("DapStopped",             {text='→', texthl='DiagnosticSignInfo',  linehl='', numhl=''})
  vim.fn.sign_define("DapBreakpointRejected",  {text='▼', texthl='DiagnosticSignWarn',  linehl='', numhl=''})

  require("nvim-dap-virtual-text").setup()
end

return M
