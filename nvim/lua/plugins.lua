local M = {}

local utils = require("utils")
local autocmd = utils.autocmd
local cmd = vim.cmd

local settings =  {
  -- UI
  { 'akinsho/bufferline.nvim' },
  { 'nvim-lualine/lualine.nvim' },

  -- Color themes
  { 'lifepillar/vim-gruvbox8', priority = 999, config = function() cmd "silent colorscheme gruvbox8_hard" end },
  { 'Lokaltog/vim-monotone', keys = "<space>z" },

  -- Extra
  { 'Shougo/deoplete.nvim', build = ':UpdateRemotePlugins',  config = function() cmd ":call deoplete#enable()" end},
  { 'cohama/lexima.vim' },
  { 'folke/which-key.nvim' },
  { 'ggandor/leap.nvim' },
  { 'junegunn/fzf', build = ':call fzf#install()' },
  { 'junegunn/fzf.vim' },
  { 'matze/vim-move' },
  { 'nvim-lua/plenary.nvim' },
  { 'nvim-telescope/telescope.nvim' },
  { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
  { 'nvim-treesitter/nvim-treesitter-context' },
  { 'tpope/vim-surround' },
  { 'vitalk/vim-shebang' },

  -- LSP
  { 'neovim/nvim-lspconfig',
    dependencies = {
      'folke/lsp-colors.nvim',
      'deoplete-plugins/deoplete-lsp',
      'simrat39/rust-tools.nvim',
    }
  },

  -- Only at work
  {'marcuscaisey/please.nvim', cond = vim.g.IS_WORK_MACHINE },
  {'mfussenegger/nvim-dap', cond = vim.g.IS_WORK_MACHINE },

  -- Not at work
  { 'eraserhd/parinfer-rust', cond = not vim.g.IS_WORK_MACHINE, build = 'cargo build --release' },
  { 'hellerve/carp-vim', ft = 'carp', cond = not vim.g.IS_WORK_MACHINE, dependencies = {'vim-syntastic/syntastic'} },
  { 'neovimhaskell/haskell-vim', ft = 'haskell',  cond = not vim.g.IS_WORK_MACHINE },
  { 'tpope/vim-rhubarb', cond = not vim.g.IS_WORK_MACHINE },

  -- Lazy
  { 'TimDeve/vim-test', event = "VeryLazy", dependencies = "benmills/vimux", branch = 'vimux-exit-copy-mode' },
  { 'airblade/vim-gitgutter', event = "VeryLazy" },
  { 'stevearc/dressing.nvim', event = "VeryLazy", config = true },
  { 'tpope/vim-fugitive', event = "VeryLazy" },

  { 'folke/trouble.nvim', cmd = "TroubleToggle" },
  { 'kyazdani42/nvim-tree.lua', cmd = {"NvimTreeToggle", "NvimTreeFindFile"} },
  { 'simnalamburt/vim-mundo', cmd = "MundoToggle" },

  { 'TimDeve/vim-todo-lists', ft = "todo" },
  { 'cespare/vim-toml', ft = 'toml' },
  { 'preservim/vim-markdown', ft = 'markdown' },
  { 'stephpy/vim-yaml', ft = 'yaml' },
  { 'luochen1990/rainbow', ft = {"clojure", "carp"}, config = function() autocmd("FileType", {"clojure", "carp"}, ":RainbowToggleOn") end },

  { 'junegunn/goyo.vim', keys = "<space>z" },
  { 'junegunn/limelight.vim', keys = "<space>z" },
  { 'mg979/vim-visual-multi', keys = "<C-N>" },
  { 'scrooloose/nerdcommenter', keys = "<space>cc" },
}

function M.setup(opts)
  require("lazy").setup(settings, {
    performance = {
      rtp = { paths = {opts.runtimepath} }
    },
    ui = {
      icons = {
        cmd = "⌘", config = "-", event = "-", ft = "-", init = "-", keys = "-",
        plugin = "-", runtime = "-", source = "-", start = "-", task = "-",
        lazy = "Zz ",
      },
    },
  })
end

return M
