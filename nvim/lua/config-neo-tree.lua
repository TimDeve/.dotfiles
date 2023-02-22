local utils = require("utils")

local M = {}

function M.setup()
  vim.cmd "let g:neo_tree_remove_legacy_commands = 1"

  -- Set colours
  vim.cmd [[
    hi Subdued ctermfg=102 guifg=#928374

    hi! link NeoTreeDirectoryName Subdued
    hi! link NeoTreeDirectoryIcon Subdued
    hi! link NeoTreeFileName      Subdued
    hi! link NeoTreeFileIcon      Subdued
  ]]

  require("neo-tree").setup({
    sources = {
      "filesystem",
      "buffers",
      "git_status",
    },
    enable_diagnostics = false,
    close_if_last_window = true,
    source_selector = {
      winbar = true,
      content_layout = "center",
      separator = { left = " ", right= "" },
      show_separator_on_edge = true,
      tab_labels = {
        filesystem  = "Files",
        buffers     = "Buffers",
        git_status  = "Git",
        diagnostics = "Diagnostics",
      },
    },
    window = {
      mappings = {
        ["<space>"] = "none", -- Removes mapping that conflicts with <leader>
      },
      auto_expand_width = true,
    },
    filesystem = {
      async_directory_scan = "always",
      use_libuv_file_watcher = true,
    },
    default_component_configs = {
      icon = {
        folder_closed = "▶",
        folder_open = "▼",
        folder_empty = "▽",
        default = " ",
      },
      git_status = {
        symbols = {
          added     = "✚",
          modified  = "✱",
          deleted   = "✖",
          renamed   = "➜",
          untracked = "✚",
          ignored   = "○",
          unstaged  = "□",
          staged    = "◼",
          conflict  = "⇆",
        },
      },
    },
  })
end

return M

