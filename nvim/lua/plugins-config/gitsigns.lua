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

      wk.register({
        ["<leader>g"] = {
          name = "Git",
          s = { "<Cmd>Gitsigns stage_hunk<CR>", "Stage hunk" },
          r = { "<Cmd>Gitsigns reset_hunk<CR>", "Reset hunk" },
        }
      }, { buffer = bufno, mode = {"n", "v"} })

      wk.register({
        ["]c"] = { next_hunk, "Next hunk" },
        ["[c"] = { prev_hunk, "Previous hunk" },
        ["<leader>g"] = {
          name = "Git",
          S = { gs.stage_buffer,    "Stage buffer" },
          R = { gs.reset_buffer,    "Reset buffer" },
          u = { gs.undo_stage_hunk, "Undo stage hunk" },
          p = { gs.preview_hunk,    "Preview hunk" },
          b = { gs.blame_line,      "Blame line" },
          d = { gs.blame_line,      "Diff buffer" },
          D = { gs.toggle_deleted,  "Toggle deleted" },
          g = { gs.toggle_signs,    "Toggle Gitsigns" },
        }
      }, { buffer = bufno })
    end
  }
end

return M

