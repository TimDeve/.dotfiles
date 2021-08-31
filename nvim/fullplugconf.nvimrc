" Deoplete
let g:deoplete#enable_at_startup = 1
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

" deoplete tab-complete
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
inoremap <expr><S-tab> pumvisible() ? "\<c-p>" : "\<S-tab>"
inoremap <expr><CR> pumvisible() ? "\<c-y>" : "\<CR>"

" omnifuncs
augroup omnifuncs
  autocmd!
  autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
  autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
  autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
  autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
  autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
augroup end

" Activate Rainbow parens only for Lisps
let g:rainbow_active = 0 " Defaults to off
autocmd FileType clojure,carp :RainbowToggleOn

" Vim-go
let g:go_fmt_command = "goimports"

" Prettier
let g:prettier#config#trailing_comma = 'es5'
let g:prettier#config#semi = 'false'
let g:prettier#config#bracket_spacing = 'true'
let g:prettier#autoformat = 0

" vim-move
let g:move_key_modifier = 'C'

" Use the right side of the screen
let g:buffergator_viewport_split_policy = 'R'

" I want my own keymappings...
let g:buffergator_suppress_keymaps = 1

" go to the previous buffer open
nmap <leader>j :BuffergatorMruCyclePrev<cr>

" Go to the next buffer open
nmap <leader>k :BuffergatorMruCycleNext<cr>

" View the entire list of buffers open
nmap <leader>bl :BuffergatorOpen<cr>

" Toggle gundo (better undo)
nnoremap <leader>u :MundoToggle<CR>

" Easymotion
map <leader><space> <Plug>(easymotion-prefix)
map <Plug>(easymotion-prefix)<space> <Plug>(easymotion-bd-w)

" Goyo
nnoremap <leader>ff :Goyo<CR>

function! s:goyo_enter()
  silent !tmux set status off
  set noshowmode
  set noshowcmd
endfunction

function! s:goyo_leave()
  silent !tmux set status on
  set showmode
  set showcmd
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

" Sneak keep searching with s
let g:sneak#s_next = 1

" vim-test
let test#strategy = "vimux" " Run test in tmux window
nnoremap <leader>T :TestNearest<CR>
nnoremap <leader>TT :TestLast<CR>
nnoremap <leader>Ts :TestSuite<CR>
nnoremap <leader>Tf :TestFile<CR>

" Silence vim go warning
let g:go_version_warning = 0

" Rust
let g:rustfmt_autosave = 1
let g:syntastic_rust_checkers = []

" LanguageClient
let g:LanguageClient_autoStart = 1
let g:LanguageClient_useFloatingHover = 1
let g:LanguageClient_fzfContextMenu = 1
let g:LanguageClient_hideVirtualTextsOnInsert = 1
" let $LANGUAGECLIENT_DEBUG=1
" let g:LanguageClient_loggingLevel='DEBUG'
" let g:LanguageClient_loggingFile =  expand('~/.local/share/nvim/LanguageClient.log')

let g:LanguageClient_serverCommands = {
    \ 'haskell':        ['haskell-language-server-wrapper', '--lsp'],
    \ 'javascript':     ['javascript-typescript-stdio'],
    \ 'javascript.jsx': ['javascript-typescript-stdio'],
    \ 'typescript':     ['typescript-language-server', '--stdio'],
    \ 'typescript.tsx': ['typescript-language-server', '--stdio'],
    \ 'rust':           ['rust-analyzer'],
    \ 'go':             ['gopls'],
    \ }

function LC_maps()
  if has_key(g:LanguageClient_serverCommands, &filetype)
    nnoremap <leader>ll :call LanguageClient_contextMenu()<CR>
    nnoremap <Leader>lh :call LanguageClient#textDocument_hover()<CR>
    nnoremap <Leader>ld :call LanguageClient#textDocument_definition()<CR>
    nnoremap <Leader>lr :call LanguageClient#textDocument_rename()<CR>
    nnoremap <Leader>lf :call LanguageClient#textDocument_formatting()<CR>
    nnoremap <Leader>lb :call LanguageClient#textDocument_references()<CR>
    nnoremap <Leader>la :call LanguageClient#textDocument_codeAction()<CR>
    nnoremap <Leader>ls :call LanguageClient#textDocument_documentSymbol()<CR>
    nnoremap <Leader>lc :call LanguageClient_handleCodeLensAction()<CR>
  endif
endfunction
autocmd FileType * call LC_maps()

" Todo
let g:VimTodoListsMoveItems = 0

" Carp
let g:syntastic_carp_checkers = ['carp']

let g:vim_markdown_folding_disabled = 1

" Extra shebang detection
AddShebangPattern! clojure ^#!.*/bin/env\s\+bb\>
AddShebangPattern! typescript ^#!.*/bin/env\s\+deno.*\>
AddShebangPattern! typescript ^#!.*/bin/env\s-S\sdeno.*\>

" Telescope
nnoremap <C-p> <cmd>Telescope find_files<cr>
nnoremap <leader>fp <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope git_files<cr>
nnoremap <leader>ff <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>ft <cmd>Telescope file_browser<cr>
nnoremap <leader>fa <cmd>Telescope builtin<cr>

