local utils = require("utils")

local M = {}
M._keys = {}
M._cmd = {}
M._ft = {}

M["todo-comments"] = function()
  local todo = require("todo-comments")

  todo.setup {
    signs = false,
    keywords = {
      FIX =  { icon = utils.signs.inverted_triangle },
      TODO = { icon = utils.signs.check },
      HACK = { icon = utils.signs.inverted_triangle },
      WARN = { icon = utils.signs.inverted_triangle },
      PERF = { icon = utils.signs.diamond },
      NOTE = { icon = utils.signs.circle },
      TEST = { icon = utils.signs.circle },
    },
    highlight = {
      keyword = "fg",
      after = "fg",
      pattern = [[.*<(KEYWORDS)(\([^\)]*\))?:]],
    },
    search = {
      pattern = [[\b(KEYWORDS)(\([^\)]*\))?:]],
    },
  }

  require("which-key").register({
    ["]t"] = { todo.jump_next, "Next todo"},
    ["[t"] = { todo.jump_prev, "Previous todo"},
  })
end

function M.lens()
  vim.cmd [[
    let g:lens#disabled = 1
    let g:lens#width_resize_min = 40
    let g:lens#disabled_filetypes = ['neo-tree']
    let g:animate#duration = 120.0
  ]]
end

M["lua-snip"] = function()
  require("luasnip.loaders.from_snipmate").lazy_load()
  vim.cmd [[
    snoremap <silent> <Tab> <cmd>lua require('luasnip').jump(1)<CR>
    snoremap <silent> <S-Tab> <cmd>lua require('luasnip').jump(-1)<CR>
  ]]
end

function M.fterm()
  vim.cmd [[ :tnoremap <C-k> <C-\><C-n>:q<CR> ]]
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

        DiagnosticSignInfo  = { bg = palette.dark0_hard, fg = palette.bright_blue },
        DiagnosticSignWarn  = { bg = palette.dark0_hard, fg = palette.bright_yellow },
        DiagnosticSignHint  = { bg = palette.dark0_hard, fg = palette.bright_aqua },
        DiagnosticSignError = { bg = palette.dark0_hard, fg = palette.bright_red },
    },
  })
  vim.cmd("colorscheme gruvbox")
end

function M.gitsigns()
  require('gitsigns').setup{
    signs = {
      add    = { text = '│' },
      change = { text = '│' },
    },
    on_attach = function(bufno)
      local wk = require('which-key')
      local gs = package.loaded.gitsigns

      local next_hunk = function()
        if vim.wo.diff then return ']c' end
        vim.schedule(function() gs.next_hunk() end)
        return '<Ignore>'
      end

      local prev_hunk = function()
        if vim.wo.diff then return '[c' end
        vim.schedule(function() gs.prev_hunk() end)
        return '<Ignore>'
      end

      wk.register({
        ["<leader>g"] = {
          name = "Git",
          s = { "<Cmd>Gitsigns stage_hunk<CR>", "Stage hunk" },
          r = { "<Cmd>Gitsigns reset_hunk<CR>", "Reset hunk" },
        }
      }, { buffer = bufno, mode = {"n", "v"} })

      wk.register({
        ["]c"] = { next_hunk, "Next hunk" },
        ["[c"] = { prev_hunk, "Previous hunk" },
        ["<leader>g"] = {
          name = "Git",
          S = { gs.stage_buffer,    "Stage buffer" },
          R = { gs.reset_buffer,    "Reset buffer" },
          u = { gs.undo_stage_hunk, "Undo stage hunk" },
          p = { gs.preview_hunk,    "Preview hunk" },
          b = { gs.blame_line,      "Blame line" },
          d = { gs.blame_line,      "Diff buffer" },
          D = { gs.toggle_deleted,  "Toggle deleted" },
          g = { gs.toggle_signs,    "Toggle Gitsigns" },
        }
      }, { buffer = bufno })
    end
  }
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
  require("true-zen").setup {
    modes = {
      ataraxis = {
        shade = "dark", -- if `dark` then dim the padding windows, otherwise if it's `light` it'll brighten said windows
        backdrop = 0, -- percentage by which padding windows should be dimmed/brightened. Must be a number between 0 and 1. Set to 0 to keep the same background color
        minimum_writing_area = { -- minimum size of main window
          width = 100,
          height = 44,
        },
        quit_untoggles = true, -- type :q or :qa to quit Ataraxis mode
        padding = { -- padding windows
          left = 999,
          right = 999,
          top = 3,
          bottom = 3,
        },
        callbacks = { -- run functions when opening/closing Ataraxis mode
          open_pre = utils.cmd_cb [[
            if g:is_in_tmux
              silent !tmux set status off
              silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
            endif

            set noshowmode
            set noshowcmd
            set scrolloff=999

            Lazy load vim-monotone
            Lazy load limelight.vim
            silent colorscheme monotone
            Monotone 0 0 70 0 0 0 0.785
            Limelight
          ]],
          open_pos = nil,
          close_pre = utils.cmd_cb [[
            if g:is_in_tmux
              silent !tmux set status on
              silent !tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z
            endif

            set showmode
            set showcmd
            set scrolloff=3

            silent colorscheme gruvbox
            Limelight!
          ]],
          close_pos = M.gruvbox
        },
      },
    },
    integrations = {
      lualine = true -- hide nvim-lualine (ataraxis)
    },
  }
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
    "bash", "c", "cpp", "go", "hcl", "javascript", "json", "lua",
    "python","norg", "norg_meta", "regex", "rust", "sql",  "toml", "tsx",
    "typescript", "vim", "yaml",
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

M["vim-todo-lists"] = function()
  utils.autocmd("FileType", {"todo"}, "call g:VimTodoListsInit()")
end

function M.leap()
  require('leap').set_default_keymaps()
end

M["telescope-live-grep-args"] = function()
  require("telescope").load_extension("live_grep_args")
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

  require('telescope').load_extension('fzf')
end

return M
