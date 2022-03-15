syntax on
filetype on

set autoindent
set autoread                                                 " reload files when changed on disk, i.e. via `git checkout`
set backspace=indent,eol,start
set backupcopy=yes                                           " see :help crontab
set clipboard=unnamed                                        " yank and paste with the system clipboard
set cursorline
set directory-=.                                             " don't store swapfiles in the current directory
set encoding=utf-8
set expandtab                                                " expand tabs to spaces
set hidden
set hlsearch
set ignorecase                                               " case-insensitive search
set incsearch                                                " search as you type
set laststatus=2                                             " always show statusline
set linebreak
set list                                                     " show trailing whitespace
set listchars=tab:▸\ ,trail:▫
set mouse=a                                                  " use mouse everywhere
set number                                                   " show line numbers
set ruler                                                    " show where you are
set scrolloff=3                                              " show context above/below cursorline
set shiftwidth=2                                             " normal mode indentation commands use 2 spaces
set showbreak=+++
set showcmd
set showmatch                                                " highlight matching [{()}]
set smartcase                                                " case-sensitive search if any caps
set softtabstop=2                                            " insert mode tab and backspace use 2 spaces
set splitbelow
set splitright
set t_Co=256
set tabstop=2                                                " actual tabs occupy 8 characters
set termguicolors
set timeoutlen=500
set undodir=$HOME/.config/nvim/undo                          " where to save undo histories
set undofile                                                 " save undo's after file closes
set undolevels=1000                                          " how many undos
set undoreload=10000                                         " number of lines to save for undo
set visualbell
set wildignore=log/**,node_modules/**,target/**,tmp/**,*.rbc " ignore these folders
set wildmenu
set wildmode=full
set inccommand=nosplit                                       " enables live preview of substitute

hi StatusLine ctermbg=238 ctermfg=234
hi WildMenu ctermbg=27 ctermfg=white

" Turns on spellcheck for git commits
autocmd FileType gitcommit setlocal spell

" md is markdown
autocmd BufRead,BufNewFile *.md set filetype=markdown
autocmd BufRead,BufNewFile *.md set spell

" zshrc is zsh
autocmd BufRead,BufNewFile *.zshrc set filetype=zsh

" tsx is tsx :)
autocmd BufNewFile,BufRead *.tsx setlocal filetype=typescript.tsx

" bats is bash
autocmd BufRead,BufNewFile *.bats set filetype=bash

" Use tabs with Go
autocmd BufRead,BufNewFile *.go set noexpandtab

" automatically rebalance windows on vim resize
autocmd VimResized * :wincmd =

let g:is_in_tmux = executable('tmux') && strlen($TMUX)

" Fix Cursor in TMUX
if g:is_in_tmux
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

silent colorscheme pablo

" space is my leader
map     <space> <leader>

" in case you forgot to sudo
cnoremap w!! %!sudo tee > /dev/null %

" Don't copy the contents of an overwritten selection.
vnoremap p "_dP

" Split navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" New Splits
nmap <leader>= :vsp<cr>
nmap <leader>- :sp<cr>

" Redo
nnoremap U <C-R>

" Move up and down even on wrapped line
noremap j gj
noremap k gk
noremap gj j
noremap gk k

" Toggle Wrap
nnoremap <leader>wr :set wrap!<CR>

" Use kj as Escape
inoremap kj <esc>

" Save
nnoremap <leader>w :w<CR>

" Quit
nnoremap <leader>q :q<CR>
nnoremap <leader>Q :qa!<CR>

" Clear search
nnoremap <leader>/ :let @/ = ""<CR>

" go to last buffer
nmap <leader><tab> <C-^>

" Close buffer
nmap <leader>bc :bp <BAR> bd #<cr>

" Close all other buffers
nnoremap <leader>bo :%bd\|e#\|bd#<CR>

nnoremap !! :!!<CR>

