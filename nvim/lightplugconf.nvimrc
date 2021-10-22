" Gruvbox
silent colorscheme gruvbox8_hard

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

  " Use ripgrep with fzf
  let FZF_DEFAULT_COMMAND = 'rg --files --hidden'
endif

nnoremap <leader>g :GitGutterToggle<CR>

" Disable sexp default for leader w
let g:sexp_mappings={
      \'sexp_round_head_wrap_element': ''
      \}

" GitGutter
set updatetime=250

