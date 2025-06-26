local M = {}

M.cmd = {
  "DiffviewFileHistory",
  "DiffviewOpen",
  "DiffviewClose",
  "DiffviewToggleFiles",
  "DiffviewFocusFiles",
  "DiffviewRefresh",
}

function M.setup()
  require("diffview").setup({
    use_icons = false,
    enhanced_diff_hl = true,
    signs = {
      fold_closed = "> ",
      fold_open = "v ",
      done = "✓ ",
    },
     hooks = {
      diff_buf_win_enter = function(bufnr, winid, ctx)
        if ctx.layout_name:match("^diff2") then
          if ctx.symbol == "a" then
            vim.opt_local.winhl = table.concat({
              vim.opt_local.winhl._value,
              "DiffChange:DiffDelete",
              "DiffText:DiffTextDelete",
            }, ",")
          end
        end
        if ctx.layout_name:match("^diff3") then
          if ctx.symbol == "a" then
            vim.opt_local.winhl = table.concat({
              vim.opt_local.winhl._value,
              "DiffChange:DiffDelete",
              "DiffText:DiffTextDelete",
            }, ",")
          end
        end
      end,
    }
  })
end

return M
