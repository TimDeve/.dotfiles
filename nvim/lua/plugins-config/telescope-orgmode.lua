local M = {}

function M.setup()
  require("telescope").load_extension("orgmode")

  vim.keymap.set("n", "<leader>o/", function()
    require("telescope").extensions.orgmode.refile_heading({
      mappings = {
        i = {
          ['<C-t>'] = require('telescope-orgmode.actions').toggle_headlines_orgfiles,
        },
        n = {
          ['<C-t>'] = require('telescope-orgmode.actions').toggle_headlines_orgfiles,
        }
      },
    })
  end)
  vim.keymap.set("n", "<leader>o?", function()
    require("telescope").extensions.orgmode.refile_heading({ mode = "orgfiles" })
  end)
  -- vim.keymap.set("n", "<leader>fh", require("telescope").extensions.orgmode.search_headings)
  vim.keymap.set("n", "<leader>oil", require("telescope").extensions.orgmode.insert_link)
  -- vim.keymap.set("n", "<leader>ot", require("telescope").extensions.orgmode.search_tags)
end

return M
