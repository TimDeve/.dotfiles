local utils = require("utils")

local M = {}

function M.setup()
  require("noice").setup({
    cmdline = {
      format = {
        cmdline = { icon = ">" },
        search_down = { icon = "/" },
        search_up = { icon = "?" },
        filter = { icon = "$" },
        lua = { icon = "☾" },
        help = { icon = "h" },
      },
    },
    format = {
      level = {
        icons = {
          error = utils.diag_signs.error,
          warn = utils.diag_signs.warn,
          info = utils.diag_signs.info,
        },
      },
    },
    popupmenu = {
      kind_icons = false,
    },
    inc_rename = {
      cmdline = {
        format = { IncRename = { icon = "⟳" } },
      },
    },
    lsp = {
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
    },
    views = {
      mini = {
        timeout = 5000,
      },
      cmdline_popup = {
        position = {
          row = "30%",
        },
      },
      --cmdline_popupmenu = {
      --  position = {
      --    row = "23",
      --  },
      --},
    },
    -- you can enable a preset for easier configuration
    presets = {
      bottom_search = true, -- use a classic bottom cmdline for search
      command_palette = false, -- use noice 
      long_message_to_split = true, -- long messages will be sent to a split
      inc_rename = false, -- disable custom dialog for inc_rename
      lsp_doc_border = false, -- add a border to hover docs and signature help
    },
  })
end

return M
