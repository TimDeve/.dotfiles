local M = {}

function M.setup()
  require('orgmode').setup({
    org_agenda_files = '~/notes/**/*.org',
    org_default_notes_file = '~/notes/0000-00-00:REFILE.org',
    org_todo_keywords = {"TODO", "WIP", "|", "DONE"},
    org_todo_keyword_faces = {
      -- ["TODO"] = ':background ' .. require("gruvbox").palette.bright_red ..' :foreground ' .. require("gruvbox").palette.dark0_hard,
      -- ["WIP"] = ':background ' .. require("gruvbox").palette.bright_yellow ..' :foreground ' .. require("gruvbox").palette.dark0_hard,
      -- ["DONE"] = ':background ' .. require("gruvbox").palette.neutral_green .. ' :foreground ' .. require("gruvbox").palette.dark0_hard,
      ["TODO"] = ':underline on :foreground ' .. require("gruvbox").palette.neutral_red,
      ["WIP"] =  ':underline on :foreground ' .. require("gruvbox").palette.bright_yellow,
      ["DONE"] = ':underline on :foreground ' .. require("gruvbox").palette.neutral_green,
    },
    org_startup_folded = "content",
    org_archive_location = "~/notes/.archive/%s_archive::",
    mappings = {
      org = {
        org_toggle_checkbox = 'cic',
      },
    },
  })
  vim.cmd [[ autocmd FileType org setlocal conceallevel=2 ]]
  -- vim.cmd [[ autocmd FileType org setlocal concealcursor='nc' ]]
  vim.cmd [[ autocmd FileType orgagenda setlocal conceallevel=2 ]]
  -- vim.cmd [[ autocmd FileType orgagenda setlocal concealcursor='nc' ]]
end

return M
