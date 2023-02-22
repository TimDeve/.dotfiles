local M = {}

local utils = require("utils")
local autocmd = utils.autocmd
local cmd_cb = utils.cmd_cb
local setup_config_cb = utils.setup_config_cb

local config = require("config-misc")

local pkgs =  {
  -- UI
  { 'Pocco81/true-zen.nvim', config = config["true-zen"], cmd = config._cmd["true-zen"] },
  { 'akinsho/bufferline.nvim', config = config.bufferline, event = "VeryLazy" },
  { 'goolord/alpha-nvim', lazy = false, config = setup_config_cb("config-alpha") },
  { 'nvim-lualine/lualine.nvim', config = setup_config_cb("config-lualine"), event = "VeryLazy" },
  { 'nvim-neo-tree/neo-tree.nvim', config = setup_config_cb("config-neo-tree"), cmd = "Neotree", dependencies = {"MunifTanjim/nui.nvim"} },

  -- Color themes
  { 'ellisonleao/gruvbox.nvim', priority = 999, config = config.gruvbox, lazy = false },
  { 'Lokaltog/vim-monotone', keys = "<space>z" },

  -- Extra
  { 'Shougo/deoplete.nvim', event = "VeryLazy", build = utils.VimEnter_cb("UpdateRemotePlugins"), config = cmd_cb("call deoplete#enable()") },
  { 'folke/which-key.nvim', lazy = false, config = setup_config_cb("config-which-key") },
  { 'ggandor/leap.nvim', event = "VeryLazy", config = config.leap },
  { 'matze/vim-move', event = "VeryLazy" },
  { 'nvim-lua/plenary.nvim' },
  { 'nvim-telescope/telescope.nvim', cmd = "Telescope", config = config.telescope },
  { 'nvim-telescope/telescope-live-grep-args.nvim', config = config["telescope-live-grep-args"] },
  { 'nvim-treesitter/nvim-treesitter', build = utils.VimEnter_cb("TSUpdate"), config = config.treesitter },
  { 'nvim-treesitter/nvim-treesitter-context', event = "VeryLazy", config = config["treesitter-context"] },
  { 'tpope/vim-surround', event = "VeryLazy" },
  { 'vitalk/vim-shebang', lazy = false },
  { 'numtostr/FTerm.nvim', config = config["fterm"] },

  -- LSP
  { 'neovim/nvim-lspconfig',
    lazy = false,
    config = setup_config_cb("config-lsp"),
    dependencies = {
      'folke/lsp-colors.nvim',
      'deoplete-plugins/deoplete-lsp',
      'jose-elias-alvarez/null-ls.nvim',
    }
  },
  { 'simrat39/rust-tools.nvim', ft = "rust", config = require("config-lsp").setup_rust_tools },

  -- Debugging
  { "rcarriga/nvim-dap-ui",
    config = require("config-dap").dapui,
    dependencies = {
      { 'mfussenegger/nvim-dap', config = setup_config_cb("config-dap") },
      { 'theHamsta/nvim-dap-virtual-text' },
    },
  },

  -- Only at work
  { 'marcuscaisey/please.nvim', ft = "please", enabled = utils.IS_WORK_MACHINE },
  { dir = '~/dev/other/vim-go', config = setup_config_cb("config-vim-go"), enabled = utils.IS_WORK_MACHINE },

  -- Not at work
  { 'eraserhd/parinfer-rust', enabled = not utils.IS_WORK_MACHINE, ft = {"clojure", "carp"}, build = 'cargo build --release' },
  { 'hellerve/carp-vim', enabled = not utils.IS_WORK_MACHINE, ft = 'carp', dependencies = {'vim-syntastic/syntastic'} },
  { 'luochen1990/rainbow', enabled = not utils.IS_WORK_MACHINE, ft = {"clojure", "carp"}, config = config.rainbow },
  { 'neovimhaskell/haskell-vim', enabled = not utils.IS_WORK_MACHINE, ft = 'haskell' },

  -- Lazy
  { 'airblade/vim-gitgutter', event = "VeryLazy" },
  { 'stevearc/dressing.nvim', event = "VeryLazy", config = true },
  { 'tpope/vim-fugitive', event = "VeryLazy" },

  { 'TimDeve/vim-test', cmd = config._cmd["vim-test"], config = config["vim-test"], dependencies = "preservim/vimux", branch = 'vimux-exit-copy-mode' },
  { 'folke/trouble.nvim', cmd = {"Trouble", "TroubleToggle"}, config = config.trouble },
  { 'simnalamburt/vim-mundo', cmd = "MundoToggle" },
  { 'preservim/vimux', cmd = config._cmd["vimux"] },

  { 'TimDeve/vim-todo-lists', ft = "todo" },
  { 'cespare/vim-toml', ft = 'toml' },
  { 'preservim/vim-markdown', ft = 'markdown' },
  { 'stephpy/vim-yaml', ft = 'yaml' },

  { 'junegunn/goyo.vim', keys = "<space>z" },
  { 'junegunn/limelight.vim', keys = "<space>z" },
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
