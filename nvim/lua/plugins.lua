local M = {}

local utils = require("utils")
local autocmd = utils.autocmd
local cmd_cb = utils.cmd_cb
local setup_config_cb = utils.setup_config_cb

local config = require("config.misc")

local pkgs =  {
  -- UI
  { 'Pocco81/true-zen.nvim', config = config["true-zen"], cmd = config._cmd["true-zen"] },
  { 'junegunn/limelight.vim' },
  { 'akinsho/bufferline.nvim', config = config.bufferline, event = "VeryLazy" },
  { 'goolord/alpha-nvim', lazy = false, config = setup_config_cb("config.alpha") },
  { 'nvim-lualine/lualine.nvim', config = setup_config_cb("config.lualine"), event = "VeryLazy" },
  { 'nvim-neo-tree/neo-tree.nvim', config = setup_config_cb("config.neo-tree"), cmd = "Neotree", dependencies = {"MunifTanjim/nui.nvim"} },
  { 'marklcrns/lens.vim', config = config["lens"], dependencies = {'camspiers/animate.vim'} },

  {
    "folke/noice.nvim",
    event = "VeryLazy",
    config = setup_config_cb("config.noice"),
    dependencies = { "MunifTanjim/nui.nvim" }
  },

  -- Color themes
  { 'ellisonleao/gruvbox.nvim', priority = 999, config = config.gruvbox, lazy = false },
  { 'Lokaltog/vim-monotone' },

  -- Completion
  { 'hrsh7th/nvim-cmp',
    event = "VeryLazy",
    config = setup_config_cb("config.nvim-cmp"),
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'petertriho/cmp-git',
      { 'L3MON4D3/LuaSnip', config = config["lua-snip"] },
      'saadparwaiz1/cmp_luasnip',
    },
  },

  -- Neorg
  {
    "nvim-neorg/neorg",
    build = ":Neorg sync-parsers",
    ft = { "norg" },
    cmd = { "Neorg" },
    --lazy = false,
    tag = "v4.6.0",
    config = setup_config_cb("config.norg"),
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      'hrsh7th/nvim-cmp',
      'nvim-telescope/telescope.nvim',
    },
  },

  -- Extra
  { 'folke/which-key.nvim', lazy = false, config = setup_config_cb("config.which-key") },
  { 'ggandor/leap.nvim', event = "VeryLazy", config = config.leap },
  { 'matze/vim-move', event = "VeryLazy" },
  { 'nvim-lua/plenary.nvim' },
  { 'nvim-telescope/telescope.nvim', cmd = "Telescope", config = config.telescope },
  { 'nvim-telescope/telescope-live-grep-args.nvim', config = config["telescope-live-grep-args"] },
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make', config = config["telescope-fzf-native"] },
  { 'nvim-treesitter/nvim-treesitter', build = "TSUpdate", event = "VeryLazy", config = config.treesitter },
  { 'nvim-treesitter/nvim-treesitter-context', event = "VeryLazy", config = config["treesitter-context"] },
  { 'tpope/vim-surround', event = "VeryLazy" },
  { 'vitalk/vim-shebang', lazy = false },
  { 'numtostr/FTerm.nvim', config = config["fterm"] },
  { 'folke/persistence.nvim', event = "BufReadPre", config = true },

  -- LSP
  { 'neovim/nvim-lspconfig',
    lazy = false,
    config = setup_config_cb("config.lsp"),
    dependencies = {
      'folke/lsp-colors.nvim',
      'jose-elias-alvarez/null-ls.nvim',
    }
  },
  { 'simrat39/rust-tools.nvim', ft = "rust", config = require("config.lsp").setup_rust_tools },

  -- Debugging
  { "rcarriga/nvim-dap-ui",
    config = require("config.dap").dapui,
    dependencies = {
      { 'mfussenegger/nvim-dap', config = setup_config_cb("config.dap") },
      { 'theHamsta/nvim-dap-virtual-text' },
    },
  },

  -- Only at work
  { 'marcuscaisey/please.nvim', ft = "please", enabled = utils.IS_WORK_MACHINE },
  { dir = '~/dev/other/vim-go', config = setup_config_cb("config.vim-go"), enabled = utils.IS_WORK_MACHINE },
  { 'folke/todo-comments.nvim', event = "VeryLazy", config = config["todo-comments"], enabled = utils.IS_WORK_MACHINE },

  -- Not at work
  { 'eraserhd/parinfer-rust', enabled = not utils.IS_WORK_MACHINE, ft = {"clojure", "carp"}, build = 'cargo build --release' },
  { 'hellerve/carp-vim', enabled = not utils.IS_WORK_MACHINE, ft = 'carp', dependencies = {'vim-syntastic/syntastic'} },
  { 'luochen1990/rainbow', enabled = not utils.IS_WORK_MACHINE, ft = {"clojure", "carp"}, config = config.rainbow },
  { 'neovimhaskell/haskell-vim', enabled = not utils.IS_WORK_MACHINE, ft = 'haskell' },

  -- Lazy
  { 'lewis6991/gitsigns.nvim', event = "VeryLazy", tag = "release", config = config["gitsigns"] },
  { 'stevearc/dressing.nvim', event = "VeryLazy", config = true },
  { 'tpope/vim-fugitive', event = "VeryLazy" },

  { 'TimDeve/vim-test', cmd = config._cmd["vim-test"], config = config["vim-test"], dependencies = "preservim/vimux", branch = 'vimux-exit-copy-mode' },
  { 'folke/trouble.nvim', cmd = {"Trouble", "TroubleToggle"}, config = config.trouble },
  { 'simnalamburt/vim-mundo', cmd = "MundoToggle" },
  { 'preservim/vimux', cmd = config._cmd["vimux"] },

  { 'TimDeve/vim-todo-lists', ft = "todo", config = config["vim-todo-lists"] },
  { 'cespare/vim-toml', ft = 'toml' },
  { 'preservim/vim-markdown', ft = 'markdown' },
  { 'stephpy/vim-yaml', ft = 'yaml' },

  { 'mg979/vim-visual-multi', keys = {{"<C-N>", mode = {"n", "v"}}}},
  { 'scrooloose/nerdcommenter', keys = {{"<space>cc", mode = {"n", "v"}}}},
}

function M.setup(opts)
  require("lazy").setup(pkgs, {
    defaults = { lazy = true },
    performance = {
      rtp = { paths = {opts.runtimepath} }
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
