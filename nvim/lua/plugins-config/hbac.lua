local M = {}

function M.setup()
  local hbac = require("hbac")

  local telescope_mappings = {
    close_unpinned = "<C-c>",
    delete_buffer = "<C-x>",
    pin_all = "<C-a>",
    unpin_all = "<C-u>",
    toggle_selections = "<C-s>",
  }

  hbac.setup({
    autoclose     = false, -- set autoclose to false if you want to close manually
    threshold     = 10,   -- hbac will start closing unedited buffers once that number is reached
    close_command = function(bufnr) vim.api.nvim_buf_delete(bufnr, {}) end,
    close_buffers_with_windows = false, -- hbac will close buffers with associated windows if this option is `true`
    telescope = {
      mappings = {
        n = telescope_mappings,
        i = telescope_mappings,
      },
      pin_icons = {
        pinned =   { " ●", hl = "DiagnosticOk" },
        unpinned = { " ○", hl = "DiagnosticWarn" },
      },
    },
  })

  -- Pin open buffer
  -- hbac.pin_all()

  require("which-key").add({
    { "<leader>b", group = "Buffers" },
    { "<leader>bo", hbac.close_unpinned, desc = "Close unedited buffers" },
    { "<leader>bp", hbac.toggle_pin, desc = "Toggle Pin" },
    { "<leader>bt", hbac.telescope, desc = "Open buffer list" },
    { "<leader>fb", hbac.telescope, desc = "Open buffer list" },
  })
end

return M
