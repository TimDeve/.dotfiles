" Bufferline
set termguicolors
lua << EOF
require("bufferline").setup{
  options = {
    buffer_close_icon = '×',
    show_close_icon = false,
    show_buffer_icons = false,
    diagnostics = false,
    numbers = "ordinal",
    left_trunc_marker = '<',
    right_trunc_marker = '>',
    enforce_regular_tabs = true,
  }
}
EOF

nmap <leader>k :BufferLineCyclePrev<cr>
nmap <leader>j :BufferLineCycleNext<cr>
nmap <leader>bp :BufferLinePick<cr>

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
let g:airline#extensions#tabline#enabled = 0
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

