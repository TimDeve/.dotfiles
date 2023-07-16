local M = {}

local utils = require("utils")
local autocmd = utils.autocmd
local cmd_cb = utils.cmd_cb
local config = utils.config_setup
local cmd = utils.config_cmd
local opts = utils.config_opts

local pkgs =  {
  -- UI
  { 'Pocco81/true-zen.nvim', config = config("true-zen"), cmd = cmd("true-zen") },
  { 'junegunn/limelight.vim' },
  { 'akinsho/bufferline.nvim', opts = opts("bufferline"), event = "VeryLazy" },
  { 'goolord/alpha-nvim', lazy = false, config = config("alpha") },
  { 'nvim-lualine/lualine.nvim', config = config("lualine"), event = "VeryLazy" },
  { 'nvim-neo-tree/neo-tree.nvim', config = config("neo-tree"), cmd = "Neotree", dependencies = {"MunifTanjim/nui.nvim"} },
  { 'marklcrns/lens.vim', config = config("lens"), dependencies = {'camspiers/animate.vim'} },

  {
    "folke/noice.nvim",
    event = "VeryLazy",
    config = config("noice"),
    dependencies = { "MunifTanjim/nui.nvim" }
  },

  -- Color themes
  { 'ellisonleao/gruvbox.nvim', priority = 999, config = config("gruvbox"), lazy = false },
  { 'Lokaltog/vim-monotone' },

  -- Completion
  { 'hrsh7th/nvim-cmp',
    event = "VeryLazy",
    config = config("nvim-cmp"),
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'petertriho/cmp-git',
      { 'L3MON4D3/LuaSnip', config = config("lua-snip") },
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
    config = config("norg"),
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      'hrsh7th/nvim-cmp',
      'nvim-telescope/telescope.nvim',
    },
  },

  -- Extra
  { 'folke/which-key.nvim', lazy = false, config = config("which-key") },
  { 'ggandor/leap.nvim', event = "VeryLazy", config = config("leap") },
  { 'matze/vim-move', event = "VeryLazy" },
  { 'nvim-lua/plenary.nvim' },
  { 'nvim-telescope/telescope.nvim', cmd = "Telescope", config = config("telescope") },
  { 'nvim-telescope/telescope-live-grep-args.nvim' },
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  { 'nvim-treesitter/nvim-treesitter', build = "TSUpdate", event = "VeryLazy", config = config("treesitter") },
  { 'nvim-treesitter/nvim-treesitter-context', config = config("treesitter-context") },
  { 'tpope/vim-surround', event = "VeryLazy" },
  { 'vitalk/vim-shebang', lazy = false },
  { 'numtostr/FTerm.nvim', config = config("fterm") },
  { 'folke/persistence.nvim', event = "BufReadPre", config = true },

  -- LSP
  { 'neovim/nvim-lspconfig',
    lazy = false,
    config = config("lsp"),
    dependencies = {
      'folke/lsp-colors.nvim',
      'jose-elias-alvarez/null-ls.nvim',
    }
  },
  { 'simrat39/rust-tools.nvim', ft = "rust", config = require("plugins-config.lsp").setup_rust_tools },

  -- Debugging
  { "rcarriga/nvim-dap-ui",
    config = require("plugins-config.dap").dapui,
    dependencies = {
      { 'mfussenegger/nvim-dap', config = config("dap") },
      { 'theHamsta/nvim-dap-virtual-text' },
    },
  },

  -- Only at work
  { 'marcuscaisey/please.nvim', ft = "please", enabled = utils.IS_WORK_MACHINE },
  { dir = '~/dev/other/vim-go', config = config("vim-go"), enabled = utils.IS_WORK_MACHINE },
  { 'folke/todo-comments.nvim', event = "VeryLazy", config = config("todo-comments"), enabled = utils.IS_WORK_MACHINE },

  -- Not at work
  { 'eraserhd/parinfer-rust', enabled = not utils.IS_WORK_MACHINE, ft = {"clojure", "carp"}, build = 'cargo build --release' },
  { 'hellerve/carp-vim', enabled = not utils.IS_WORK_MACHINE, ft = 'carp', dependencies = {'vim-syntastic/syntastic'} },
  { 'luochen1990/rainbow', enabled = not utils.IS_WORK_MACHINE, ft = {"clojure", "carp"}, config = config("rainbow") },
  { 'neovimhaskell/haskell-vim', enabled = not utils.IS_WORK_MACHINE, ft = 'haskell' },

  -- Lazy
  { 'lewis6991/gitsigns.nvim', event = "VeryLazy", tag = "release", config = config("gitsigns") },
  { 'stevearc/dressing.nvim', event = "VeryLazy", config = true },
  { 'tpope/vim-fugitive', event = "VeryLazy" },

  { 'TimDeve/vim-test', cmd = cmd("vim-test"), config = config("vim-test"), dependencies = "preservim/vimux", branch = 'vimux-exit-copy-mode' },
  { 'folke/trouble.nvim', cmd = {"Trouble", "TroubleToggle"}, opts = opts("trouble") },
  { 'simnalamburt/vim-mundo', cmd = "MundoToggle" },
  { 'preservim/vimux', cmd = cmd("vimux") },

  { 'TimDeve/vim-todo-lists', ft = "todo", config = config("vim-todo-lists") },
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
