local M = {}

function M.setup()
    local startify = require('alpha.themes.startify')
    startify.nvim_web_devicons.enabled = false
    require'alpha'.setup(startify.config)
end

return M
