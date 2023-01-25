local M = {}

local utils = require("utils")
local autocmd = utils.autocmd
local cmd_cb = utils.cmd_cb
local setup_config_cb = utils.setup_config_cb

local config = require("config-misc")

local pkgs =  {
  -- UI
  { 'akinsho/bufferline.nvim', config = config.bufferline },
  { 'nvim-lualine/lualine.nvim', config = setup_config_cb("config-lualine") },
  { 'nvim-neo-tree/neo-tree.nvim', config = setup_config_cb("config-neo-tree"), cmd = "Neotree", dependencies = {"MunifTanjim/nui.nvim"} },
  { 'Pocco81/true-zen.nvim', config = config["true-zen"], cmd = config._cmd["true-zen"] },

  -- Color themes
  { 'lifepillar/vim-gruvbox8', priority = 999, config = cmd_cb("silent colorscheme gruvbox8_hard") },
  { 'Lokaltog/vim-monotone', keys = "<space>z" },

  -- Extra
  { 'Shougo/deoplete.nvim', build = utils.VimEnter_cb("UpdateRemotePlugins"), config = cmd_cb("call deoplete#enable()") },
  { 'folke/which-key.nvim', config = setup_config_cb("config-which-key") },
  { 'ggandor/leap.nvim', config = config.leap },
  { 'junegunn/fzf.vim', dependencies = {{ 'junegunn/fzf', build = ':call fzf#install()' }}},
  { 'matze/vim-move' },
  { 'nvim-lua/plenary.nvim', lazy = true },
  { 'nvim-telescope/telescope.nvim', config = config.telescope },
  { 'nvim-treesitter/nvim-treesitter', build = utils.VimEnter_cb("TSUpdate"), config = config.treesitter },
  { 'nvim-treesitter/nvim-treesitter-context', config = config["treesitter-context"] },
  { 'tpope/vim-surround' },
  { 'vitalk/vim-shebang' },

  -- LSP
  { 'neovim/nvim-lspconfig',
    config = setup_config_cb("config-lsp"),
    dependencies = {
      'folke/lsp-colors.nvim',
      'deoplete-plugins/deoplete-lsp',
      'simrat39/rust-tools.nvim',
      'jose-elias-alvarez/null-ls.nvim',
    }
  },

  -- Only at work
  { 'marcuscaisey/please.nvim', ft = "please", enabled = utils.IS_WORK_MACHINE },
  { 'mfussenegger/nvim-dap', lazy = true, enabled = utils.IS_WORK_MACHINE },
  { dir = '~/dev/other/vim-go', ft = require("config-vim-go").ft, config = setup_config_cb("config-vim-go"), enabled = utils.IS_WORK_MACHINE },
  --{ 'nvim-telescope/telescope-frecency.nvim', enabled = utils.IS_WORK_MACHINE, config = config["telescope-frecency"], lazy = true, dependencies = {"kkharji/sqlite.lua"} }, -- Needs to be forked to use rg/fd

  -- Not at work
  { 'eraserhd/parinfer-rust', enabled = not utils.IS_WORK_MACHINE, ft = {"clojure", "carp"}, build = 'cargo build --release' },
  { 'hellerve/carp-vim', enabled = not utils.IS_WORK_MACHINE, ft = 'carp', dependencies = {'vim-syntastic/syntastic'} },
  { 'luochen1990/rainbow', enabled = not utils.IS_WORK_MACHINE, ft = {"clojure", "carp"}, config = config.rainbow },
  { 'neovimhaskell/haskell-vim', enabled = not utils.IS_WORK_MACHINE, ft = 'haskell' },
  { 'tpope/vim-rhubarb', enabled = not utils.IS_WORK_MACHINE },

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
