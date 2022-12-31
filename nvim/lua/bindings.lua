local wk = require("which-key")

function setup()
  wk.setup {
    popup_mappings = {
      scroll_up = '<c-p>',
      scroll_down = '<c-n>',
    },
  }

  -- Normal mode mappings
  wk.register({
    U      = { "<C-R>",       "Redo" },
    j      = { "gj",          "Next Line"},
    k      = { "gk",          "Previous Line"},
    gj     = { "j",           "Next Line (Skip Wrap)"},
    gk     = { "k",           "Previous Line (Skip Wrap)"},
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
        a = { "<Cmd>Telescope builtin<CR>",                "Builtins" },
        b = { "<Cmd>Telescope buffers<CR>",                "Buffers" },
        f = { "<Cmd>Telescope live_grep<CR>",              "Grep" },
        g = { "<Cmd>Telescope git_files<CR>",              "Git files" },
        p = { "<Cmd>Telescope find_files<CR>",             "Find files" },
        P = { "<Cmd>Telescope find_files hidden=true<CR>", "Find all files" },
        t = { "<Cmd>Telescope file_browser<CR>",           "File browser" },
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
      Q  = { "<Cmd>qa!<CR>",                 "Force quit all" },
      W  = { "<Cmd>wa<CR>",                  "Save all" },
      cc = { "<Plug>NERDCommenterToggle",    "Toggle comment" },
      ll = { "<Cmd>TroubleToggle<CR>",       "Open Trouble" },
      e  = { vim.diagnostic.open_float,      "Show diagnostic for this line" },
      g  = { "<Cmd>GitGutterToggle<CR>",     "Toggle GitGutter" },
      j  = { "<Cmd>BufferLineCycleNext<CR>", "Next buffer" },
      k  = { "<Cmd>BufferLineCyclePrev<CR>", "Previous buffer" },
      q  = { "<Cmd>q<CR>",                   "Quit" },
      r  = { "<Cmd>set wrap!<CR>",           "Toggle wrap" },
      u  = { "<CMd>MundoToggle<CR>",         "Toggle undo tree" },
      w  = { "<Cmd>w<CR>",                   "Save" },
      z  = { "<Cmd>Goyo<CR>",                "Zen mode" },
    }
  })

  -- Visual mode mappings
  wk.register(
    {
      ["<leader>cc"] = { "<Plug>NERDCommenterToggle", "Toggle comment" },
      ["<CR>"]       = { "y",                         "Yank" },
    },
    { mode = "v" }
  )
end

return { setup = setup }
