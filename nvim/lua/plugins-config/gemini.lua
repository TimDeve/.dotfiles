local M = {}

function M.setup()
  require("gemini").setup({
    cmds = { "gemini" },
    on_buf = function(buf)
      vim.api.nvim_buf_set_keymap(buf, 't', '<C-h>', [[<C-\><C-n>:wincmd h<CR>]], { noremap = true, silent = true, desc = 'Move to left window' })
      -- Default to insert mode in this buffer
      vim.api.nvim_create_autocmd("BufEnter", {
        buffer = buf,
        callback = function() vim.cmd("startinsert") end,
      })
    end
  })
end

M.keys = {
  { "<leader>aa", "<cmd>GeminiToggle<cr>", desc = "Toggle Gemini sidebar" },
  { "<leader>af", "<cmd>GeminiSwitchToCli<cr>", desc = "Spawn or switch to AI session" },
  { '<leader>as', '<cmd>GeminiSend<cr>', mode = { 'x' }, desc = 'Send selection to Gemini' },
}

return M
