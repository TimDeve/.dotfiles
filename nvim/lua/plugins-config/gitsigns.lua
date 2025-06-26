local M = {}

function M.setup()
  require('gitsigns').setup{
    signs = {
      add    = { text = '│' },
      change = { text = '│' },
    },
    on_attach = function(bufno)
      local wk = require('which-key')
      local gs = package.loaded.gitsigns

      local next_hunk = function()
        if vim.wo.diff then return ']c' end
        vim.schedule(function() gs.next_hunk() end)
        return '<Ignore>'
      end

      local prev_hunk = function()
        if vim.wo.diff then return '[c' end
        vim.schedule(function() gs.prev_hunk() end)
        return '<Ignore>'
      end

      wk.add({
        mode = { "n", "v" },
        buffer = bufno,
        { "<leader>g", buffer = bufno, group = "Git" },
        { "<leader>gr", "<Cmd>Gitsigns reset_hunk<CR>", desc = "Reset hunk" },
        { "<leader>gs", "<Cmd>Gitsigns stage_hunk<CR>", desc = "Stage hunk" },
      })

      wk.add({
        buffer = bufno,
        { "<leader>g", group = "Git" },
        { "<leader>gS", gs.stage_buffer,   desc = "Stage buffer" },
        { "<leader>gR", gs.reset_buffer,   desc = "Reset buffer" },
        { "<leader>gu", gs.undo_stage_hunk,desc = "Undo stage hunk" },
        { "<leader>gp", gs.preview_hunk,   desc = "Preview hunk" },
        { "<leader>gb", gs.blame_line,     desc = "Blame line" },
        { "<leader>gD", gs.toggle_deleted, desc = "Toggle deleted" },
        { "<leader>gg", gs.toggle_signs,   desc = "Toggle Gitsigns" },
        { "[c", prev_hunk, desc = "Previous hunk" },
        { "]c", next_hunk, desc = "Next hunk" },
      })
    end
  }
end

return M
