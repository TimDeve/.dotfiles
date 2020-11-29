Plug 'Raimondi/delimitMate'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'TimDeve/vim-todo-lists'
Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next','do': 'bash install.sh' }
Plug 'benmills/vimux'
Plug 'brooth/far.vim'
Plug 'easymotion/vim-easymotion'
Plug 'eraserhd/parinfer-rust', { 'do': 'cargo build --release' }
Plug 'janko-m/vim-test'
Plug 'jeetsukumaran/vim-buffergator'
Plug 'jonhiggs/vim-readline'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/goyo.vim'
Plug 'luochen1990/rainbow'
Plug 'matze/vim-move'
Plug 'mcchrish/nnn.vim'
Plug 'mitermayer/vim-prettier', { 'do': 'npm install', 'tag': '1.0.0-alpha', 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'html', 'yaml'] }
Plug 'neovim/node-host', {'do' : 'npm install'}
Plug 'rbgrouleff/bclose.vim'
Plug 'sakhnik/nvim-gdb', { 'do': ':!./install.sh' }
Plug 'sebdah/vim-delve'
Plug 'terryma/vim-multiple-cursors'
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-fugitive'
Plug 'vim-syntastic/syntastic'

" Languages
Plug 'cespare/vim-toml'
Plug 'hellerve/carp-vim'
Plug 'neovimhaskell/haskell-vim'
Plug 'rhysd/vim-crystal'
Plug 'stephpy/vim-yaml'
Plug 'ziglang/zig.vim'

