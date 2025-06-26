local utils = require("utils")
local autocmd = require("utils.vim").autocmd
local conform = require('plugins-config.conform')

local function set_testing_strategy(strategy)
  return function() vim.g["test#strategy"] = strategy end
end

local function file_search(opts)
  --if utils.IS_WORK_MACHINE then
  --  return function() require('telescope').extensions.frecency.frecency({ workspace = 'CWD' }) end
  --else
    return function() utils.project_files(opts) end
  --end
end

local function open_buf_folder()
  vim.cmd 'VimuxRunCommand "cd " . expand("%:p:h")'
end

local function close_other_buffers()
  local bufferline = require("bufferline")
  bufferline.close_in_direction("left")
  bufferline.close_in_direction("right")
end

function setup()
  local wk = require("which-key")

  wk.setup {
    keys = {
      scroll_up = "<c-p>",
      scroll_down = "<c-n>",
    },
    plugins = {
      marks = false, -- Disable because it doesn't respect timeout
    },
    icons = {
      mappings = false,
      keys = {
        Up = "↑",
        Down = "↓",
        Left = "←",
        Right = "→",
        C = "⌃",
        M = "⌥",
        S = "⇧",
        CR = "⏎",
        Esc = "⎋",
        ScrollWheelDown = "⇟",
        ScrollWheelUp = "⇞",
        NL = "⏎",
        Space = "␣",
        Tab = "⇥",
        BS = "⌫ ",

        F1 = "F1 ",
        F2 = "F2 ",
        F3 = "F3 ",
        F4 = "F4 ",
        F5 = "F5 ",
        F6 = "F6 ",
        F7 = "F7 ",
        F8 = "F8 ",
        F9 = "F9 ",
        F10 = "F10 ",
        F11 = "F11 ",
        F12 = "F12 ",
      },
    },
  }

  -- Normal mode mappings
  wk.add({
    { "!!", "<Cmd>!!<CR>", desc = "Replay Last Shell Command" },
    { "<C-p>", file_search(), desc = "Find files" },
    { "J", "<Plug>MoveLineDown", desc = "Move line down" },
    { "K", "<Plug>MoveLineUp", desc = "Move line up" },
    { "U", "<C-R>", desc = "Redo" },
    { "[d", function() vim.diagnostic.goto_prev({severity = { min = vim.diagnostic.severity.WARN }}) end, desc = "Previous diagnostic" },
    { "]d", function() vim.diagnostic.goto_next({severity = { min = vim.diagnostic.severity.WARN }}) end, desc = "Next diagnostic" },
    { "gj", "j", desc = "Next Line (Skip Wrap)" },
    { "gk", "k", desc = "Previous Line (Skip Wrap)" },
    { "j", "gj", desc = "Next Line" },
    { "k", "gk", desc = "Previous Line" },
    { "z=", "<Cmd>Telescope spell_suggest<CR>", desc = "Spelling suggestions" },

    { "<leader>-", "<Cmd>sp<CR>", desc = "Horizontal split" },
    { "<leader>/", '<Cmd>let @/ = ""<CR>', desc = "Clear search" },
    { "<leader>;", "<Cmd>lua require'FTerm'.toggle()<CR>", desc = "Open floating term" },
    { "<leader><tab>", "<C-^>", desc = "Switch to previous buffer" },
    { "<leader>=", "<Cmd>vsp<CR>", desc = "Vertical split" },
    { "<leader>e", vim.diagnostic.open_float, desc = "Show diagnostic for this line" },
    { "<leader>j", "<Cmd>BufferLineCycleNext<CR>", desc = "Next buffer" },
    { "<leader>k", "<Cmd>BufferLineCyclePrev<CR>", desc = "Previous buffer" },
    { "<leader>q", "<Cmd>q<CR>", desc = "Quit" },
    { "<leader>r", "<Cmd>set wrap!<CR>", desc = "Toggle wrap" },
    { "<leader>u", "<CMd>MundoToggle<CR>", desc = "Toggle undo tree" },
    { "<leader>w", "<Cmd>w<CR>", desc = "Save" },
    { "<leader>Q", "<Cmd>qa!<CR>", desc = "Force quit all" },
    { "<leader>W", "<Cmd>wa<CR>", desc = "Save all" },

    { "<leader>lf", conform.format, desc = "Format" },
    { "<leader>ll", "<Cmd>Trouble diagnostics toggle filter.buf=0 filter.severity=vim.diagnostic.severity.ERROR<CR>", desc = "Open Trouble" },

    { "<leader>F", group = "Search & Replace" },
    { "<leader>FF", "<Cmd>lua require'spectre'.toggle()<CR>", desc = "Toggle" },
    { "<leader>Fp", "<Cmd>lua require'spectre'.open_file_search({select_word=true})<CR>", desc = "Search current word in file" },
    { "<leader>Fw", "<Cmd>lua require'spectre'.open_visual({select_word=true})<CR>", desc = "Search current word" },

    { "<leader>b", group = "Buffers" },
    { "<leader>bC", "<Cmd>bp <BAR> bd! #<CR>", desc = "Force close buffer" },
    { "<leader>bO", close_other_buffers, desc = "Close other buffers" },
    { "<leader>bb", "<Cmd>BufferLinePick<CR>", desc = "Pick buffer" },
    { "<leader>bc", "<Cmd>bp <BAR> bd #<CR>", desc = "Close buffer" },
    { "<leader>bf", open_buf_folder, desc = "Open buffer's folder" },
    { "<leader>cc", "<Plug>NERDCommenterToggle", desc = "Toggle comment" },

    { "<leader>d", group = "Debugging" },
    { "<leader>dB", "<Cmd>lua require'dap'.clear_breakpoints()<CR>", desc = "Clear breakpoints" },
    { "<leader>dT", "<Cmd>lua require'dap'.terminate()<CR>", desc = "Terminate session" },
    { "<leader>db", "<Cmd>lua require'dap'.toggle_breakpoint()<CR>", desc = "Toggle breakpoint" },
    { "<leader>dc", "<Cmd>lua require'dap'.continue()<CR>", desc = "Continue" },
    { "<leader>dd", "<Cmd>lua require'dap'.step_over()<CR>", desc = "Step over" },
    { "<leader>dh", "<Cmd>lua require'dap'.run_to_cursor()<CR>", desc = "Run until here" },
    { "<leader>di", "<Cmd>lua require'dap'.step_into()<CR>", desc = "Step into" },
    { "<leader>do", "<Cmd>lua require'dap'.step_out()<CR>", desc = "Step out" },
    { "<leader>dp", "<Cmd>lua require'please'.debug()<CR>", desc = "Plz debug target" },
    { "<leader>dr", "<Cmd>lua require'dap'.run_last()<CR>", desc = "Restart session" },
    { "<leader>du", "<Cmd>lua require'dapui'.toggle()<CR>", desc = "Toggle UI" },

    { "<leader>f", group = "Telescope" },
    { "<leader>f'", "<Cmd>Telescope marks<CR>", desc = "Marks" },
    { "<leader>fF", "<Cmd>Telescope live_grep<CR>", desc = "Grep fzf" },
    { "<leader>fP", file_search({ hidden = true }), desc = "Find all files" },
    { "<leader>fa", "<Cmd>Telescope builtin<CR>", desc = "Builtins" },
    { "<leader>ff", "<Cmd>Telescope live_grep_args<CR>", desc = "Grep" },
    { "<leader>fo", "<Cmd>Telescope oldfiles cwd_only=true<CR>", desc = "Oldfiles" },
    { "<leader>fp", file_search(), desc = "Find files" },
    { "<leader>ft", "<Cmd>TodoTelescope<CR>", desc = "Todos" },
    { "<leader>fw", "<Cmd>Telescope grep_string<CR>", desc = "Grep word" },

    { "<leader>g", group = "Git" },
    { "<leader>gB", "<Cmd>Git blame<CR>", desc = "Show git blame" },
    { "<leader>gd", "<Cmd>DiffviewOpen<CR>", desc = "Diff buffer" },
    { "<leader>gh", "<Cmd>DiffviewFileHistory %<CR>", desc = "Show file history" },

    { "<leader>s", group = "Sidebar" },
    { "<leader>sb", "<Cmd>Neotree buffers<CR>", desc = "Show buffers" },
    { "<leader>sc", "<Cmd>Neotree close<CR>", desc = "Close" },
    { "<leader>sf", "<Cmd>Neotree filesystem reveal<CR>", desc = "Go to current file" },
    { "<leader>sg", "<Cmd>Neotree git_status<CR>", desc = "Show git status" },
    { "<leader>ss", "<Cmd>Neotree filesystem<CR>", desc = "Focus" },

    { "<leader>t", group = "Test" },
    { "<leader>tf", "<Cmd>TestFile<CR>", desc = "File" },
    { "<leader>tg", "<Cmd>TestVisit<CR>", desc = "Go to test file" },
    { "<leader>tn", "<Cmd>TestNearest<CR>", desc = "Nearest" },
    { "<leader>ts", "<Cmd>TestSuite<CR>", desc = "Suite" },
    { "<leader>tt", "<Cmd>TestLast<CR>", desc = "Last" },

    { "<leader>to", group = "Test Output Location" },
    { "<leader>tob", set_testing_strategy("basic"), desc = "Buffer terminal" },
    { "<leader>tos", set_testing_strategy("neovim"), desc = "Split terminal" },
    { "<leader>tot", set_testing_strategy("vimux"), desc = "Tmux" },

    { "<leader>z", group = "Zoom" },
    { "<leader>zc", "<Cmd>TZAtaraxis<CR>", desc = "Zen mode" },
    { "<leader>zz", "<Cmd>TZFocus<CR>", desc = "Zoom current window" },
  })

  -- Visual mode mappings
  wk.add(
    {
      mode = { "v" },
      { "<CR>", "y", desc = "Yank" },
      { "<leader>cc", "<Plug>NERDCommenterToggle", desc = "Toggle comment" },
      { "<leader>gh", "<Cmd>:'<,'>DiffviewFileHistory<CR>", desc = "Show file history" },
      { "J", "<Plug>MoveBlockDown", desc = "Move block down" },
      { "K", "<Plug>MoveBlockUp", desc = "Move block up" },
    }
  )
end

return { setup = setup }
