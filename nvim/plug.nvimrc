call plug#begin()

" Base
Plug 'airblade/vim-gitgutter'
Plug 'akinsho/bufferline.nvim'
Plug 'scrooloose/nerdcommenter'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Color themes
Plug 'lifepillar/vim-gruvbox8'
Plug 'Lokaltog/vim-monotone'

" Extra
" Plug 'janko-m/vim-test'
" Plug 'sakhnik/nvim-gdb', { 'do': ':!./install.sh' }
" Plug 'sebdah/vim-delve'
" Plug 'kkharji/sqlite.lua'
" Plug 'nvim-telescope/telescope-smart-history.nvim'
Plug 'Raimondi/delimitMate'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'TimDeve/vim-test', { 'branch': 'vimux-exit-copy-mode' }
Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next','do': 'bash install.sh' }
Plug 'benmills/vimux'
Plug 'brooth/far.vim'
Plug 'eraserhd/parinfer-rust', { 'do': 'cargo build --release' }
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
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-surround'
Plug 'vim-syntastic/syntastic'
Plug 'vitalk/vim-shebang'

" Languages
" Plug 'rhysd/vim-crystal'
" Plug 'ziglang/zig.vim'
Plug 'TimDeve/vim-todo-lists'
Plug 'cespare/vim-toml'
Plug 'hellerve/carp-vim'
Plug 'neovimhaskell/haskell-vim'
Plug 'preservim/vim-markdown'
Plug 'stephpy/vim-yaml'

call plug#end()
