local M = {}

M.opts = {
  options = {
    buffer_close_icon = '×',
    close_command = function(bufNo)
      local currentBufNo = vim.api.nvim_get_current_buf()
      if currentBufNo == bufNo then
        require("bufferline").cycle(-1)
      end
      vim.api.nvim_buf_delete(bufNo, { force = true })
      require("bufferline.ui").refresh()
    end,
    show_close_icon = false,
    show_buffer_icons = false,
    diagnostics = false,
    numbers = "ordinal",
    left_trunc_marker = '◀',
    right_trunc_marker = '▶',
    tab_size = 16,
    max_name_length = 26,
    enforce_regular_tabs = false,
  }
}

return M

