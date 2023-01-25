local utils = require("utils")

local M = {}
M._keys = {}
M._cmd = {}
M._ft = {}

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
          if choice < 1 or choice > #items then
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
