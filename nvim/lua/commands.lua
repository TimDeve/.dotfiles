local utils = require("utils")

if utils.IS_WORK_MACHINE then
  vim.cmd [[ command! PlzUpdateTargets execute '! plz puku fmt %:h' ]]
end

vim.cmd [[ command GitLastMessage r ! git log -1 --pretty=format:\%B ]]

-- Session
vim.cmd [[ command SessionLoad     lua require("persistence").load() ]]
vim.cmd [[ command SessionLoadLast lua require("persistence").load({ last = true }) ]]
vim.cmd [[ command SessionStop     lua require("persistence").stop() ]]

vim.cmd [[ command LensToggle Lazy load lens.vim | call lens#toggle() ]]

vim.api.nvim_create_user_command('SgLink',
  function(details)
    require("sourcegraph").open_location(details.range ~= 0, details.fargs[1])
  end,
  { nargs = '*', range = true }
)
