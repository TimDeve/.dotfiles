local utils = require("utils")

local M = {}
M._keys = {}
M._cmd = {}
M._ft = {}

M._cmd["vim-test"] = {"TestFile", "TestNearest", "TestLast", "TestFile", "TestVisit"}
M["vim-test"] = function()
  if vim.g.is_in_tmux then
    vim.g["test#strategy"] = "vimux"
  else
    vim.g["test#strategy"] = "neovim"
  end

  if utils.has_exe('richgo') then
    vim.g["test#go#runner"] = "richgo"
  end
end

M.bufferline = {
  options = {
    buffer_close_icon = '×',
    show_close_icon = false,
    show_buffer_icons = false,
    diagnostics = false,
    numbers = "ordinal",
    left_trunc_marker = '<',
    right_trunc_marker = '>',
    tab_size = 16,
    max_name_length = 26,
    enforce_regular_tabs = false,
  }
}

M.trouble = {
  icons = false,
  fold_open = "v",
  fold_closed = ">",
  indent_lines = false,
  use_diagnostic_signs = true,
  signs = utils.diag_signs,
}

M["nvim-tree"] = {
  git = {
    enable = false
  },
  view = {
    signcolumn = "no"
  },
  renderer = {
    icons = {
      padding = "",
      glyphs = {
        default = "",
        symlink = "",
        folder = {
          arrow_open = "v",
          arrow_closed = ">",
          default = "",
          open = "",
          empty = "",
          empty_open = "",
          symlink = "",
          symlink_open = ""
        }
      },
      show = {
        file = false,
        folder = true,
        folder_arrow = true,
        git = false
      }
    }
  }
}

function M.treesitter()
  local treesitter_langs = {
    "bash", "c", "cpp", "go", "hcl", "javascript", "json", "lua", "markdown",
    "markdown_inline", "python", "regex", "rust", "sql",  "toml", "tsx",
    "typescript", "vim", "yaml"
  }
  for _, lang in ipairs(treesitter_langs) do
    treesitter_langs[lang] = true
  end

  local treesitter_settings = {
    highlight = {
      enable = true,
      disable = function(lang) return treesitter_langs[lang] ~= true end,
    },
  }

  if utils.has_exe("tree-sitter") then
    treesitter_settings.ensure_installed = treesitter_langs
  end

  require('nvim-treesitter.configs').setup(treesitter_settings)

  require('treesitter-context').setup({
    patterns = {
      go = {
        'function_declaration',
      },
    },
  })
end

function M.rainbow()
  autocmd("FileType", {"clojure", "carp"}, ":RainbowToggleOn")
end

function M.leap()
  require('leap').set_default_keymaps()
end

function M.telescope()
  require('telescope').setup{
    defaults = {
      mappings = {
        n = {
          ["k"] = require('telescope.actions').cycle_history_prev,
          ["j"] = require('telescope.actions').cycle_history_next,
        }
      },
    },
  }
end

return M
