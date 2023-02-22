local utils = require("utils")

local M = {}
M._keys = {}
M._cmd = {}
M._ft = {}

M["telescope-live-grep-args"] = function()
  require("telescope").load_extension("live_grep_args")
end

function M.fterm()
  vim.cmd [[ :tnoremap <Esc> <C-\><C-n>:q<CR> ]]
end

function M.gruvbox()
  local palette = require("gruvbox.palette").colors
  require("gruvbox").setup({
    contrast = "hard",
    overrides = {
        SignColumn     = { bg = palette.dark0_hard },
        GitSignsChange = { fg = palette.bright_aqua,  bg = nil },
        GitSignsAdd    = { fg = palette.bright_green, bg = nil },
        GitSignsDelete = { fg = palette.bright_red,   bg = nil },
    },
  })
  vim.cmd("colorscheme gruvbox")
  vim.cmd [[
    hi! link GitGutterAdd    GitSignsAdd
    hi! link GitGutterChange GitSignsChange
    hi! link GitGutterDelete GitSignsDelete
  ]]
end

M._cmd["vimux"] = {
  "VimuxRunCommand",
  "VimuxSendText",
  "VimuxSendKeys",
  "VimuxOpenRunner",
  "VimuxRunLastCommand",
  "VimuxCloseRunner",
  "VimuxInspectRunner",
  "VimuxInterruptRunner",
  "VimuxPromptCommand",
  "VimuxClearTerminalScreen",
  "VimuxClearRunnerHistory",
  "VimuxZoomRunner",
  "VimuxRunCommandInDir",
}

M._cmd["true-zen"] = {"TZNarrow", "TZFocus", "TZMinimalist", "TZAtaraxis"}
M["true-zen"] = function()
end

M._cmd["vim-test"] = {"TestFile", "TestNearest", "TestLast", "TestFile", "TestVisit"}
M["vim-test"] = function()
  local preferred_target = {}
  if utils.IS_WORK_MACHINE then
    vim.g["test#go#runner"] = "gotest"
    vim.g["test#custom_transformations"] = {
      plzgotransform = function(cmd)
        local has_go_test = string.find(cmd, "go test")
        if has_go_test == nil then
          return cmd -- No need to transform test that are not go tests
        end

        local filepath = vim.api.nvim_buf_get_name(0)
        local pquery = require('please.query')
        local plz_root = pquery.reporoot(filepath)
        local test_targets = pquery.whatinputs(plz_root, filepath)
        local targets_len = #test_targets
        local test_target

        if targets_len > 1 then
          local saved = preferred_target[filepath]

          if saved ~= nil then
            test_target = saved
          end

          local choice = vim.fn.inputlist(test_targets)
          if choice < 1 or choice > #test_targets then
            return "echo 'No valid targets'"
          end
          test_target = test_targets[choice]
          preferred_target[filepath] = test_target
        elseif targets_len == 0 then
          return "echo 'No target found'"
        else
          test_target = test_targets[1]
        end

        local nice_output = " | go tool test2json | gotestsum -f testname --raw-command -- cat"

        -- If targeting a specific test
        local i, _, target, folder = string.find(cmd, "-run%s(.+)%s(.+)")
        if i ~= nil then
          return "plz --profile=noremote run " .. test_target .. " -- -test.v -test.run " .. target .. nice_output
        end

        -- If targeting a folder
        local i, _, folder = string.find(cmd, "go test%s%./(.+)/...")
        if i ~= nil then
          return "plz --profile=noremote run " .. test_target .. nice_output
        end

        return "echo 'Could not match a test'"
      end
    }
    vim.g["test#transformation"] = "plzgotransform"
  else
    if vim.g.is_in_tmux then
      vim.g["test#strategy"] = "vimux"
    end

    if utils.has_exe('richgo') then
      vim.g["test#go#runner"] = "richgo"
    end
  end
end

M["telescope-frecency"] = function()
  require"telescope".load_extension("frecency")
end

M.bufferline = {
  options = {
    buffer_close_icon = '×',
    show_close_icon = false,
    show_buffer_icons = false,
    diagnostics = false,
    numbers = "ordinal",
    left_trunc_marker = '◀',
    right_trunc_marker = '▶',
    tab_size = 16,
    max_name_length = 26,
    enforce_regular_tabs = false,
  }
}

M.trouble = {
  icons = false,
  fold_open = "▼",
  fold_closed = "▶",
  indent_lines = false,
  use_diagnostic_signs = true,
  signs = utils.diag_signs,
}

function M.treesitter()
  local treesitter_langs = {
    "bash", "c", "cpp", "go", "hcl", "javascript", "json", "lua", "python",
    "regex", "rust", "sql",  "toml", "tsx", "typescript", "vim", "yaml"
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
end

M["treesitter-context"] = {
  patterns = {
    go = {
      'function_declaration',
    },
  },
}

function M.rainbow()
  utils.autocmd("FileType", {"clojure", "carp"}, "call rainbow_main#load()")
end

function M.leap()
  require('leap').set_default_keymaps()
end

function M.telescope()
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
      mappings = {
        i = {
          ["<C-j>"] = lga_actions.quote_prompt(),
          ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob *." }),
          ["<C-h>"] = lga_actions.quote_prompt({ postfix = " --no-ignore" }),
          ["<C-t>"] = open_with_trouble,
        },
        n = {
          ["k"] = require('telescope.actions').cycle_history_prev,
          ["j"] = require('telescope.actions').cycle_history_next,
        }
      },
    },
  }
end

return M
