local utils = require("utils")

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

function setup()
  local wk = require("which-key")

  wk.setup {
    popup_mappings = {
      scroll_up = '<c-p>',
      scroll_down = '<c-n>',
    },
    plugins = {
      marks = false, -- Disable because it doesn't respect timeout
      spelling = {
        enabled = true,
        suggestions = 20,
      },
    },
  }

  -- Normal mode mappings
  wk.register({
    U      = { "<C-R>",                  "Redo" },
    J      = { "<Plug>MoveLineDown",     "Move line down"},
    K      = { "<Plug>MoveLineUp",       "Move line up"},
    j      = { "gj",                     "Next Line"},
    k      = { "gk",                     "Previous Line"},
    gj     = { "j",                      "Next Line (Skip Wrap)"},
    gk     = { "k",                      "Previous Line (Skip Wrap)"},
    ["!!"] = { "<Cmd>!!<CR>",            "Replay Last Shell Command" },
    ["[d"] = { vim.diagnostic.goto_prev, "Previous diagnostic" },
    ["]d"] = { vim.diagnostic.goto_next, "Next diagnostic" },
    ["<C-p>"] = { file_search(), "Find files" },
    ["<leader>"] = {
      ["<tab>"] = { "<C-^>",                     "Switch to previous buffer" },
      ["="]     = { "<Cmd>vsp<CR>",              "Vertical split" },
      ["-"]     = { "<Cmd>sp<CR>",               "Horizontal split" },
      ["/"]     = { "<Cmd>let @/ = \"\"<CR>",    "Clear search", },
      b = {
        name = "Buffers",
        b = { "<Cmd>BufferLinePick<CR>", "Pick buffer" },
        c = { "<Cmd>bp <BAR> bd #<CR>",  "Close buffer" },
        C = { "<Cmd>bp <BAR> bd! #<CR>", "Force close buffer" },
        f = { open_buf_folder,           "Open buffer's folder" },
        o = { "<Cmd>%bd|e#|bd#<CR>",     "Close other buffers" },
      },
      f = {
        name = "Telescope",
        ["'"] = { "<Cmd>Telescope marks<CR>",    "Marks" },
        a = { "<Cmd>Telescope builtin<CR>",      "Builtins" },
        b = { "<Cmd>Telescope buffers<CR>",      "Buffers" },
        f = { "<Cmd>Telescope live_grep<CR>",    "Grep" },
        p = { file_search(),                     "Find files" },
        P = { file_search({ hidden = true }),    "Find all files" },
        t = { "<Cmd>Telescope file_browser<CR>", "File browser" },
      },
      g = {
        name = "Git",
        b = { "<Cmd>Git blame<CR>",       "Show git blame" },
        g = { "<Cmd>GitGutterToggle<CR>", "Toggle GitGutter" },
      },
      s = {
        name = "Sidebar",
        c = { "<Cmd>Neotree close<CR>",             "Close" },
        f = { "<Cmd>Neotree filesystem reveal<CR>", "Go to current file" },
        s = { "<Cmd>Neotree filesystem<CR>",        "Focus" },
        g = { "<Cmd>Neotree git_status<CR>",        "Show git status" },
        b = { "<Cmd>Neotree buffers<CR>",           "Show buffers" },
      },
      t = {
        name = "Test",
        t = { "<Cmd>TestLast<CR>",    "Last" },
        f = { "<Cmd>TestFile<CR>",    "File" },
        n = { "<Cmd>TestNearest<CR>", "Nearest" },
        s = { "<Cmd>TestSuite<CR>",   "Suite" },
        g = { "<Cmd>TestVisit<CR>",   "Go to test file" },
        o = {
          name = "Test Output Location",
          s = { set_testing_strategy("neovim"), "Split terminal" },
          b = { set_testing_strategy("basic"),  "Buffer terminal" },
          t = { set_testing_strategy("vimux"),  "Tmux" },
        },
      },
      z = {
        name = "Zoom",
        z = { "<Cmd>TZFocus<CR>", "Zoom current window" },
        c = { "<Cmd>Goyo<CR>",    "Zen mode" },
      },
      Q  = { "<Cmd>qa!<CR>",                                 "Force quit all" },
      W  = { "<Cmd>wa<CR>",                                 "Save all" },
      cc = { "<Plug>NERDCommenterToggle",                   "Toggle comment" },
      ll = { "<Cmd>TroubleToggle document_diagnostics<CR>", "Open Trouble" },
      e  = { vim.diagnostic.open_float,                     "Show diagnostic for this line" },
      j  = { "<Cmd>BufferLineCycleNext<CR>",                "Next buffer" },
      k  = { "<Cmd>BufferLineCyclePrev<CR>",                "Previous buffer" },
      q  = { "<Cmd>q<CR>",                                  "Quit" },
      r  = { "<Cmd>set wrap!<CR>",                          "Toggle wrap" },
      u  = { "<CMd>MundoToggle<CR>",                        "Toggle undo tree" },
      w  = { "<Cmd>w<CR>",                                  "Save" },
    }
  })

  -- Visual mode mappings
  wk.register(
    {
      J              = { "<Plug>MoveBlockDown",       "Move block down"},
      K              = { "<Plug>MoveBlockUp",         "Move block up"},
      ["<leader>cc"] = { "<Plug>NERDCommenterToggle", "Toggle comment" },
      ["<CR>"]       = { "y",                         "Yank" },
    },
    { mode = "v" }
  )
end

return { setup = setup }
