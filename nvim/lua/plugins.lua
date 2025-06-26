local M = {}

local utils = require("utils")
local cfg = utils.config_setup
local cmd = utils.config_cmd
local opts = utils.config_opts
local keys = utils.config_keys

local pkgs =  {
  -- UI
  { 'Pocco81/true-zen.nvim', config = cfg("true-zen"), cmd = cmd("true-zen") },
  { 'junegunn/limelight.vim' },
  { 'akinsho/bufferline.nvim', config = cfg("bufferline"), event = "VeryLazy" },
  { 'goolord/alpha-nvim', lazy = false, config = cfg("alpha") },
  { 'nvim-lualine/lualine.nvim', config = cfg("lualine"), event = "VeryLazy" },
  { 'nvim-neo-tree/neo-tree.nvim', config = cfg("neo-tree"), cmd = "Neotree", dependencies = {"MunifTanjim/nui.nvim"} },
  { 'marklcrns/lens.vim', config = cfg("lens"), dependencies = {'camspiers/animate.vim'} },

  {
    "folke/noice.nvim",
    event = "VeryLazy",
    config = cfg("noice"),
    dependencies = { "MunifTanjim/nui.nvim" }
  },

  -- Color themes
  { 'ellisonleao/gruvbox.nvim', priority = 999, config = cfg("gruvbox"), lazy = false },
  { 'Lokaltog/vim-monotone' },

  -- Completion
  { 'hrsh7th/nvim-cmp',
    event = "VeryLazy",
    config = cfg("nvim-cmp"),
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'petertriho/cmp-git',
      { 'L3MON4D3/LuaSnip', config = cfg("lua-snip"), build = "make install_jsregexp" },
      'saadparwaiz1/cmp_luasnip',
    },
  },

  -- Neorg
  {
    "nvim-neorg/neorg",
    ft = { "norg" },
    cmd = { "Neorg" },
    tag = "v9.1.1",
    config = cfg("norg"),
  },

  -- Extra
  { 'folke/which-key.nvim', event = "VeryLazy", config = cfg("which-key") },
  { 'ggandor/leap.nvim', keys = keys("leap"), config = cfg("leap") },
  { 'matze/vim-move', keys = keys("vim-move") },
  { 'nvim-lua/plenary.nvim' },
  { 'nvim-telescope/telescope.nvim', cmd = "Telescope", config = cfg("telescope") },
  { 'nvim-telescope/telescope-live-grep-args.nvim' },
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  { 'nvim-treesitter/nvim-treesitter', build = ":TSUpdate", event = "VeryLazy", config = cfg("treesitter") },
  { 'nvim-treesitter/nvim-treesitter-context', config = cfg("treesitter-context") },
  { 'tpope/vim-surround', event = "VeryLazy" },
  { 'vitalk/vim-shebang', lazy = false },
  { 'numtostr/FTerm.nvim', config = cfg("fterm") },
  { 'folke/persistence.nvim', event = "BufReadPre", opts = opts("persistence") },
  { 'eraserhd/parinfer-rust', ft = utils.lisp_ft, build = 'cargo build --release' },
  { 'luochen1990/rainbow', ft = {"clojure", 'carp'}, config = cfg("rainbow") },
  { 'axkirillov/hbac.nvim', config = cfg("hbac") },
  { 'direnv/direnv.vim', ft = "direnv", config = cfg("direnv") },
  { 'sindrets/diffview.nvim', config = cfg("diffview"), cmd = cmd("diffview") },
  { 'nvim-pack/nvim-spectre', dependencies = { 'nvim-lua/plenary.nvim' }, opts = {} },
  { 'dhruvasagar/vim-table-mode', keys = keys("vim-table-mode"), cmd = cmd("vim-table-mode") },
  { "hat0uma/csvview.nvim", opts = opts("csvview"), cmd = cmd("csvview") },

  -- LSP
  { 'neovim/nvim-lspconfig', lazy = false, config = cfg("lsp") },
  { 'simrat39/rust-tools.nvim', ft = "rust", config = require("plugins-config.lsp").setup_rust_tools },
  { 'mfussenegger/nvim-lint', ft = {"go", "sh", "markdown"}, config = cfg("nvim-lint") },
  { 'stevearc/conform.nvim', config = cfg("conform") },
  { 'jmbuhr/otter.nvim', dependencies = {'nvim-treesitter/nvim-treesitter'} },

  -- Debugging
  { "rcarriga/nvim-dap-ui",
    config = require("plugins-config.dap").dapui,
    dependencies = {
      { 'mfussenegger/nvim-dap', config = cfg("dap") },
      { 'theHamsta/nvim-dap-virtual-text' },
      { 'nvim-neotest/nvim-nio' },
    },
  },

  -- Only at work
  { 'marcuscaisey/please.nvim', ft = "please", enabled = utils.IS_WORK_MACHINE },
  { 'folke/todo-comments.nvim', event = "VeryLazy", config = cfg("todo-comments"), enabled = utils.IS_WORK_MACHINE },

  -- Not at work
  { 'hellerve/carp-vim', enabled = not utils.IS_WORK_MACHINE, ft = 'carp', dependencies = {'vim-syntastic/syntastic'} },
  { 'neovimhaskell/haskell-vim', enabled = not utils.IS_WORK_MACHINE, ft = 'haskell' },

  -- Lazy
  { 'lewis6991/gitsigns.nvim', cmd = "GitSigns", event = "VeryLazy", tag = "release", config = cfg("gitsigns") },
  { 'stevearc/dressing.nvim', event = "VeryLazy", config = true },
  { 'tpope/vim-fugitive', event = "VeryLazy" },

  { 'TimDeve/vim-test', cmd = cmd("vim-test"), config = cfg("vim-test"), dependencies = "preservim/vimux", branch = 'vimux-exit-copy-mode' },
  { 'folke/trouble.nvim', cmd = {"Trouble", "TroubleToggle"}, opts = opts("trouble") },
  { 'simnalamburt/vim-mundo', cmd = "MundoToggle" },
  { 'preservim/vimux', cmd = cmd("vimux") },

  { 'preservim/vim-markdown', ft = 'markdown' },

  { 'mg979/vim-visual-multi', keys = {{"<C-N>", mode = {"n", "v"}}}},
  { 'scrooloose/nerdcommenter', keys = {{"<space>cc", mode = {"n", "v"}}}},

  -- LLMs
  { 'gsuuon/llm.nvim', config = cfg("llm"), cmd = cmd("llm"), enabled = utils.enabled_if_env("LLAMACPP_DIR") },
  {
    "nomnivore/ollama.nvim",
    dependencies = {"nvim-lua/plenary.nvim"},
    cmd = cmd("ollama"),
    keys = keys("ollama"),
    opts = opts("ollama"),
    enabled = utils.enabled_if_exe("ollama")
  }
}

function M.setup(options)
  require("lazy").setup(pkgs, {
    defaults = { lazy = true },
    performance = {
      rtp = { paths = {options.runtimepath} }
    },
    ui = {
      icons = {
        cmd = "[cmd]", config = "[conf]", event = "[event]", ft = "[ftype]",
        init = "[init]", keys = "[keys]", plugin = "[plug]", runtime = "[rtime]",
        source = "[src]", start = "->", task = "[task]", lazy = "Zz ",
      },
    },
  })
end

return M
