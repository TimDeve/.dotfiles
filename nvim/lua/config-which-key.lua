local utils = require("utils")

function setup()
  local wk = require("which-key")

  wk.setup {
    popup_mappings = {
      scroll_up = '<c-p>',
      scroll_down = '<c-n>',
    },
  }

  -- Normal mode mappings
  wk.register({
    U      = { "<C-R>",              "Redo" },
    J      = { "<Plug>MoveLineDown", "Move line down"},
    K      = { "<Plug>MoveLineUp",   "Move line up"},
    j      = { "gj",                 "Next Line"},
    k      = { "gk",                 "Previous Line"},
    gj     = { "j",                  "Next Line (Skip Wrap)"},
    gk     = { "k",                  "Previous Line (Skip Wrap)"},
    ["!!"] = { "<Cmd>!!<CR>", "Replay Last Shell Command" },
    ["[d"] = { vim.diagnostic.goto_prev, "Previous diagnostic" },
    ["]d"] = { vim.diagnostic.goto_next, "Next diagnostic" },
    ["<C-p>"] = { "<Cmd>Telescope find_files<CR>", "Find files" },
    ["<leader>"] = {
      ["<tab>"] = { "<C-^>",                     "Switch to previous buffer" },
      ["="]     = { "<Cmd>vsp<CR>",              "Vertical split" },
      ["-"]     = { "<Cmd>sp<CR>",               "Horizontal split" },
      ["/"]     = { "<Cmd>let @/ = \"\"<CR>",    "Clear search", },
      b = {
        name = "Buffers",
        c = { "<Cmd>bp <BAR> bd #<CR>",  "Close buffer"},
        C = { "<Cmd>bp <BAR> bd! #<CR>", "Force close buffer"},
        o = { "<Cmd>%bd|e#|bd#<CR>",     "Close other buffers"},
        p = { "<Cmd>BufferLinePick<CR>", "Pick buffer"},
      },
      f = {
        name = "Telescope",
        ["'"] = { "<Cmd>Telescope marks<CR>",              "marks" },
        a = { "<Cmd>Telescope builtin<CR>",                "Builtins" },
        b = { "<Cmd>Telescope buffers<CR>",                "Buffers" },
        f = { "<Cmd>Telescope live_grep<CR>",              "Grep" },
        p = { utils.project_files,                         "Find files" },
        P = { function() utils.project_files({ hidden = true }) end, "Find all files" },
        t = { "<Cmd>Telescope file_browser<CR>",           "File browser" },
      },
      g = {
        name = "Git",
        b = { "<Cmd>Git blame<CR>",       "Show git blame" },
        g = { "<Cmd>GitGutterToggle<CR>", "Toggle GitGutter" },
      },
      s = {
        name = "File Browser",
        c = { "<Cmd>NvimTreeClose<CR>",    "Close sidebar" },
        f = { "<Cmd>NvimTreeFindFile<CR>", "Go to current file" },
        s = { "<Cmd>NvimTreeToggle<CR>",   "Toggle sidebar" },
      },
      t = {
        name = "Test",
        t = { "<Cmd>TestLast<CR>",    "Last" },
        f = { "<Cmd>TestFile<CR>",    "File" },
        n = { "<Cmd>TestNearest<CR>", "Nearest" },
        s = { "<Cmd>TestSuite<CR>",   "Suite" },
        g = { "<Cmd>TestVisit<CR>",   "Go to test file" },
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
      z  = { "<Cmd>Goyo<CR>",                               "Zen mode" },
    }
  })

  -- Visual mode mappings
  wk.register(
    {
      J      = { "<Plug>MoveBlockDown", "Move block down"},
      K      = { "<Plug>MoveBlockUp",   "Move block up"},
      ["<leader>cc"] = { "<Plug>NERDCommenterToggle", "Toggle comment" },
      ["<CR>"]       = { "y",                         "Yank" },
    },
    { mode = "v" }
  )
end

return { setup = setup }
