local M = {}

M.cmd = {"Tableize", "TableModeToggle", "TableModeRealign"}
M.keys = {
  "<Leader>mm",
  {"<Leader>mr", "<Cmd>TableModeRealign<CR>", desc = "Realign table" },
}

return M
