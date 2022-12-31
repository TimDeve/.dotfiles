" in case you forgot to sudo
cnoremap w!! %!sudo tee > /dev/null %

" Don't copy the contents of an overwritten selection.
vnoremap p "_dP

" Enter key copies in visual to match tmux behaviour
vnoremap <CR> y

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
nnoremap <leader>r :set wrap!<CR>

" Save
nnoremap <leader>w :w<CR>

" Quit
nnoremap <leader>q :q<CR>
nnoremap <leader>Q :qa!<CR>
