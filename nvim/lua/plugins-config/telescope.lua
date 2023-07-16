local M = {}

function M.setup()
  local palette = require("gruvbox.palette").colors
  local groups = {
    TelescopePromptNormal  = { bg = palette.dark0_soft },
    TelescopeResultsNormal = { bg = palette.dark0 },
    TelescopePreviewNormal = { bg = palette.dark0 },

    TelescopeSelection      = { bg = palette.dark0_soft, fg = palette.light0_hard, bold = true },
    TelescopeSelectionCaret = { fg = palette.bright_red, bg = palette.dark0_soft, bold = true },
    TelescopePreviewTitle   = { bg = palette.bright_red, fg = palette.dark0, bold = true },
    TelescopeResultsTitle   = { bg = palette.bright_red, fg = palette.dark0, bold = true },
    TelescopePromptTitle    = { bg = palette.bright_red, fg = palette.dark0, bold = true },
    TelescopeTitle          = { bg = palette.bright_red, fg = palette.dark0, bold = true },
    TelescopeBorder         = { fg = palette.dark0_soft, bg = palette.dark0_soft },

    TelescopePromptBorder  = { bg = palette.dark0_soft, fg = palette.dark0_soft },
    TelescopeResultsBorder = { bg = palette.dark0,      fg = palette.dark0 },
    TelescopePreviewBorder = { bg = palette.dark0,      fg = palette.dark0 },

    TelescopePromptPrefix = { bg = palette.dark0_soft, fg = palette.bright_red }
  }

  for group, config in pairs(groups) do
    vim.api.nvim_set_hl(0, group, config)
  end

  local lga_actions = require("telescope-live-grep-args.actions")
  local open_with_trouble = function(arg) require("trouble.providers.telescope").open_with_trouble(arg) end

  require('telescope').setup{
    defaults = {
      layout_strategy = "horizontal",
      layout_config = {
        horizontal = {
          prompt_position = "top",
        },
      },
      sorting_strategy = "ascending",
      path_display = { truncate = true, shorten = 4 },
      mappings = {
        i = {
          ["<C-j>"] = lga_actions.quote_prompt(),
          ["<C-k>"] = lga_actions.quote_prompt({ postfix = " --iglob *." }),
          ["<C-f>"] = lga_actions.quote_prompt({ postfix = " -F" }),
          ["<C-h>"] = lga_actions.quote_prompt({ postfix = " --no-ignore" }),
          ["<C-t>"] = open_with_trouble,
        },
        n = {
          ["k"] = require('telescope.actions').cycle_history_prev,
          ["j"] = require('telescope.actions').cycle_history_next,
        }
      },
    },
    pickers = {
      buffers = {
        mappings = {
          i = {
            ["<c-d>"] = "delete_buffer",
          }
        }
      }
    },
    extensions = {
      fzf = {
        fuzzy = true,                    -- false will only do exact matching
        override_generic_sorter = true,  -- override the generic sorter
        override_file_sorter = true,     -- override the file sorter
        case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
      }
    }
  }

  require("telescope").load_extension("fzf")
  require("telescope").load_extension("live_grep_args")
end

return M

