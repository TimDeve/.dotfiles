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
nnoremap <leader>lcst :LanguageClientStart<CR>
nnoremap <leader>lcsp :LanguageClientStop<CR>

function LC_maps()
  if has_key(g:LanguageClient_serverCommands, &filetype)
    nnoremap <leader>ss :call LanguageClient_contextMenu()<CR>

    nnoremap <leader>R :call LanguageClient_textDocument_rename()<CR>
    nnoremap <leader>A :call LanguageClient_textDocument_codeAction()<CR>
    nnoremap <leader>D :call LanguageClient_textDocument_definition()<CR>
    nnoremap <leader>H :call LanguageClient_textDocument_hover()<CR>
    nnoremap <leader>S :call LanguageClient_workspace_symbol()<CR>
  endif
endfunction
autocmd FileType * call LC_maps()

let g:LanguageClient_serverCommands = {
    \ 'javascript':     ['javascript-typescript-stdio'],
    \ 'javascript.jsx': ['javascript-typescript-stdio'],
    \ 'typescript':     ['javascript-typescript-stdio'],
    \ 'typescript.tsx': ['javascript-typescript-stdio'],
    \ 'typescript.jsx': ['javascript-typescript-stdio'],
    \ 'rust':           ['rust-analyzer'],
    \ 'go':             ['gopls'],
    \ }

" Todo
let g:VimTodoListsMoveItems = 0
