local utils = require("utils")

if utils.IS_WORK_MACHINE then
  vim.cmd [[ command! PlzUpdateTargets execute '! plz update-go-targets %:h' ]]
end

vim.cmd [[ command GitLastMessage r ! git log -1 --pretty=format:\%B ]]

-- Session
vim.cmd [[ command SessionLoad     lua require("persistence").load() ]]
vim.cmd [[ command SessionLoadLast lua require("persistence").load({ last = true }) ]]
vim.cmd [[ command SessionStop     lua require("persistence").stop() ]]

vim.cmd [[ command LensToggle Lazy load lens.vim | call lens#toggle() ]]

vim.cmd [[ command -range SgLink lua require("sourcegraph").open_location() ]]
