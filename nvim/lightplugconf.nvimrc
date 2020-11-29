" Gruvbox
let g:gruvbox_contrast_dark='hard'
silent colorscheme gruvbox
set background=dark

" NerdCommenter
let g:NERDDefaultAlign = 'left'
let g:NERDCommentEmptyLines = 1
let NERDCreateDefaultMappings = 0
let g:NERDCustomDelimiters = { 'carp': { 'left': ';' } }
map <leader>cc <plug>NERDCommenterToggle

""" Airline Stuff
let g:airline_powerline_fonts = 1
let g:airline_theme='raven'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#whitespace#mixed_indent_algo = 1
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''

let g:ctrlp_match_window = 'order:ttb,max:20'
let g:NERDSpaceDelims=1

if executable('rg')
  set grepprg=rg\ --color=never
  let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'
  let g:ctrlp_use_caching = 0

  " Use ripgrep with fzf
  let FZF_DEFAULT_COMMAND = 'rg --files --hidden'
endif

" Setup some default ignores
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/](\.(git|hg|svn)|\_site)$',
  \ 'file': '\v\.(exe|so|dll|class|png|jpg|jpeg)$',
\}

" Use the nearest .git directory as the cwd
" This makes a lot of sense if you are working on a project that is in version
" control. It also supports works with .svn, .hg, .bzr.
let g:ctrlp_working_path_mode = 'r'

" Easy bindings for its various modes
nmap <C-b> :CtrlPBuffer<cr>

nnoremap <leader>g :GitGutterToggle<CR>

" Disable sexp default for leader w
let g:sexp_mappings={
      \'sexp_round_head_wrap_element': ''
      \}

" GitGutter
set updatetime=250

