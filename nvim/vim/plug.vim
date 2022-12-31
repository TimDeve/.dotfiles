call plug#begin()

" Base
Plug 'airblade/vim-gitgutter'
Plug 'akinsho/bufferline.nvim'
Plug 'scrooloose/nerdcommenter'

" Color themes
Plug 'lifepillar/vim-gruvbox8'
Plug 'Lokaltog/vim-monotone'

" Extra
Plug 'Raimondi/delimitMate'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'TimDeve/vim-test', { 'branch': 'vimux-exit-copy-mode' }
Plug 'benmills/vimux'
Plug 'brooth/far.vim'
Plug 'deoplete-plugins/deoplete-lsp'
Plug 'folke/lsp-colors.nvim'
Plug 'folke/trouble.nvim'
Plug 'folke/which-key.nvim'
Plug 'ggandor/leap.nvim'
Plug 'jonhiggs/vim-readline'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
Plug 'kyazdani42/nvim-tree.lua'
Plug 'luochen1990/rainbow'
Plug 'matze/vim-move'
Plug 'mg979/vim-visual-multi'
Plug 'neovim/node-host', {'do' : 'npm install'}
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-context'
Plug 'simnalamburt/vim-mundo'
Plug 'simrat39/rust-tools.nvim'
Plug 'stevearc/dressing.nvim'
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'vim-syntastic/syntastic'
Plug 'vitalk/vim-shebang'

if g:IS_WORK_MACHINE
  Plug 'marcuscaisey/please.nvim'
  Plug 'mfussenegger/nvim-dap'
else
  Plug 'eraserhd/parinfer-rust', { 'do': 'cargo build --release' }
  Plug 'hellerve/carp-vim'
  Plug 'neovimhaskell/haskell-vim'
  Plug 'tpope/vim-rhubarb'
endif

" Languages
" Plug 'rhysd/vim-crystal'
" Plug 'ziglang/zig.vim'
Plug 'TimDeve/vim-todo-lists'
Plug 'cespare/vim-toml'
Plug 'preservim/vim-markdown'
Plug 'stephpy/vim-yaml'

call plug#end()
