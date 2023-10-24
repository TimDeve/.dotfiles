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
    enable_diagnostics = false,
    close_if_last_window = true,
    source_selector = {
      winbar = true,
      content_layout = "center",
      separator = { left = " ", right= "" },
      show_separator_on_edge = true,
      sources = {
        { source = "filesystem",       display_name = "Files" },
        { source = "buffers",          display_name = "Buffers" },
        { source = "git_status",       display_name = "Git" },
        { source = "document_symbols", display_name = "Symbols" },
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
      window = {
        mappings = {
          ["tf"] = "telescope_find",
          ["g"] = "telescope_grep",
        },
      },
      commands = {
        telescope_find = function(state)
          local node = state.tree:get_node()
          local path = node:get_id()
          require('telescope.builtin').find_files({ cwd = path, search_dirs = { path }})
        end,
        telescope_grep = function(state)
          local node = state.tree:get_node()
          local path = node:get_id()
          require('telescope').extensions.live_grep_args.live_grep_args({ cwd = path, search_dirs = { path }})
        end,
      },
    },
    default_component_configs = {
      icon = {
        folder_closed = "▶",
        folder_open = "▼",
        folder_empty = "▽",
        default = " ",
      },
      created        = { enabled = false },
      file_size      = { enabled = false },
      last_modified  = { enabled = false },
      symlink_target = { enabled = false },
      type           = { enabled = false },
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

