local utils = require("utils")

if utils.IS_WORK_MACHINE then
  vim.cmd [[ command! PlzUpdateTargets execute '! plz update-go-targets %:h' ]]
end

vim.cmd [[ command GitLastMessage r ! git log -1 --pretty=format:\%B ]]

