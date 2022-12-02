" Gruvbox
silent colorscheme gruvbox8_hard

" NerdCommenter
let g:NERDDefaultAlign = 'left'
let g:NERDCommentEmptyLines = 1
let NERDCreateDefaultMappings = 0
let g:NERDCustomDelimiters = { 'carp': { 'left': ';' } }

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

" Disable sexp default for leader w
let g:sexp_mappings={
      \'sexp_round_head_wrap_element': ''
      \}

" GitGutter
set updatetime=250

" Deoplete
let g:deoplete#enable_at_startup = 1
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif
autocmd FileType TelescopePrompt call deoplete#custom#buffer_option('auto_complete', v:false)

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
let g:move_key_modifier = 'S'

function! s:goyo_enter()
  if g:is_in_tmux
    silent !tmux set status off
    silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z

    let l:timeout = reltimefloat(reltime()) + 0.5
    while reltimefloat(reltime()) < l:timeout
      let l:res = system("sh -c \"tmux list-panes -F '#{E:window_zoomed_flag}' | head -c 1\"")
      sleep 1m
      if l:res == '1'
        break
      endif
    endwhile

    " Need to pass default width (80) to Goyo to tell
    " it to turn on rather than toggle.
    execute 'Goyo 80'
  endif

  set noshowmode
  set noshowcmd
  set scrolloff=999

  silent colorscheme monotone
  Monotone 0 0 70 0 0 0 0.785
  Limelight
endfunction

function! s:goyo_leave()
  if g:is_in_tmux
    silent !tmux set status on
    silent !tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z
  endif

  set showmode
  set showcmd
  set scrolloff=3

  silent colorscheme gruvbox8_hard
  Limelight!

  call s:setup_bufferline()
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

" vim-test
if g:is_in_tmux
  let test#strategy = "vimux"
else
  let test#strategy = "neovim"
endif

let test#go#runner = "richgo"

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

function g:LanguageClientRestart()
  LanguageClientStop
  sleep 500m
  LanguageClientStart
endfunction
command LanguageClientRestart call g:LanguageClientRestart()

function g:LanguageClientRustFeatures(...)
  let g:LanguageClient_serverCommands
    \.rust
    \.initializationOptions
    \.cargo
    \.features = a:000
  call g:LanguageClientRestart()
endfunction
command -nargs=* LanguageClientRustFeatures call g:LanguageClientRustFeatures(<f-args>)

function g:LanguageClientDebug()
  let $LANGUAGECLIENT_DEBUG=1
  let g:LanguageClient_loggingLevel='DEBUG'
  let g:LanguageClient_loggingFile = expand('~/.local/share/nvim/LanguageClient.log')
  call g:LanguageClientRestart()
endfunction
command LanguageClientDebug call g:LanguageClientDebug()

let g:LanguageClient_serverCommands = {
    \ 'haskell':        ['haskell-language-server-wrapper', '--lsp'],
    \ 'javascript':     ['javascript-typescript-stdio'],
    \ 'javascript.jsx': ['javascript-typescript-stdio'],
    \ 'typescript':     ['typescript-language-server', '--stdio'],
    \ 'typescript.tsx': ['typescript-language-server', '--stdio'],
    \ 'python':         ['pylsp'],
    \ 'go':             ['gopls'],
    \ 'rust': {
    \     'name': 'rust-analyzer',
    \     'command': ['rust-analyzer'],
    \     'initializationOptions': {
    \       'cargo': { 'features': 'all' }
    \     }
    \ },
\ }

" Todo
let g:VimTodoListsMoveItems = 0

" Carp
let g:syntastic_carp_checkers = ['carp']

let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_new_list_item_indent = 0
let g:vim_markdown_frontmatter = 1

" Extra shebang detection
AddShebangPattern! clojure ^#!.*/bin/env\s\+bb\>
AddShebangPattern! typescript ^#!.*/bin/env\s\+deno.*\>
AddShebangPattern! typescript ^#!.*/bin/env\s-S\sdeno.*\>

" Use cross platform clipboard if on WSL
if system('uname -a | egrep [Mm]icrosoft') != ''
  if executable('win32yank.exe')
    set clipboard+=unnamedplus
    let g:clipboard = {
    \   'name': 'win32yank-wsl',
    \   'copy': {
    \      '+': 'win32yank.exe -i --crlf',
    \      '*': 'win32yank.exe -i --crlf',
    \    },
    \   'paste': {
    \      '+': 'win32yank.exe -o --lf',
    \      '*': 'win32yank.exe -o --lf',
    \   },
    \   'cache_enabled': 0,
    \ }
  endif
endif

" Leap
lua require('leap').set_default_keymaps()

" Bufferline
function s:setup_bufferline()
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
    tab_size = 16,
    max_name_length = 26,
    enforce_regular_tabs = false,
  }
}
EOF
endfunction
call s:setup_bufferline()

lua << LUA
require('nvim-tree').setup {
  git = {
    enable = false
  },
  view = {
    signcolumn = "no"
  },
  renderer = {
    icons = {
      padding = "",
      glyphs = {
        default = "",
        symlink = "",
        folder = {
          arrow_open = "v",
          arrow_closed = ">",
          default = "",
          open = "",
          empty = "",
          empty_open = "",
          symlink = "",
          symlink_open = ""
        }
      },
      show = {
        file = false,
        folder = true,
        folder_arrow = true,
        git = false
      }
    }
  }
}
LUA

lua << LUA
require('telescope').setup{
  defaults = {
    mappings = {
      n = {
        ["k"] = require('telescope.actions').cycle_history_prev,
        ["j"] = require('telescope.actions').cycle_history_next,
      }
    },
--     history = {
--      path = '~/.local/share/nvim/databases/telescope_history.sqlite3',
--      limit = 100,
--    },
  },
}

-- require('telescope').load_extension('smart_history')
LUA

lua << LUA
require("which-key").setup {
  popup_mappings = {
    scroll_up = '<c-p>',
    scroll_down = '<c-n>',
  },
}

local wk = require("which-key")

-- Normal mode mappings
wk.register({
  ["!!"] = { "<Cmd>!!<CR>", "Replay Last Shell Command" },
  ["<C-p>"] = { "<Cmd>Telescope find_files<CR>", "Find files" },
  ["<leader>"] = {
    ["<space>"] = { "<Plug>(easymotion-prefix)", "Easymotion" },
    ["<tab>"]   = { "<C-^>",                     "Switch to previous buffer" },
    ["="]       = { "<Cmd>vsp<CR>",              "Vertical split" },
    ["-"]       = { "<Cmd>sp<CR>",               "Horizontal split" },
    ["/"]       = { "<Cmd>let @/ = \"\"<CR>",    "Clear search", },
    b = {
      name = "Buffers",
      c = { "<Cmd>bp <BAR> bd #<CR>",  "Close buffer"},
      C = { "<Cmd>bp <BAR> bd! #<CR>", "Force close buffer"},
      o = { "<Cmd>%bd|e#|bd#<CR>",     "Close other buffers"},
      p = { "<Cmd>BufferLinePick<CR>", "Pick buffer"},
    },
    f = {
      name = "Telescope",
      a = { "<Cmd>Telescope builtin<CR>",                "Builtins" },
      b = { "<Cmd>Telescope buffers<CR>",                "Buffers" },
      f = { "<Cmd>Telescope live_grep<CR>",              "Grep" },
      g = { "<Cmd>Telescope git_files<CR>",              "Git files" },
      p = { "<Cmd>Telescope find_files<CR>",             "Find files" },
      P = { "<Cmd>Telescope find_files hidden=true<CR>", "Find all files" },
      t = { "<Cmd>Telescope file_browser<CR>",           "File browser" },
    },
    s = {
      name = "File Browser",
      c = { "<Cmd>NvimTreeClose<CR>",    "Close sidebar" },
      f = { "<Cmd>NvimTreeFindFile<CR>", "Go to current file" },
      s = { "<Cmd>NvimTreeFocus<CR>",    "Focus sidebar" },
    },
    t = {
      name = "Test",
      t = { "<Cmd>TestLast<CR>",    "Last" },
      f = { "<Cmd>TestFile<CR>",    "File" },
      n = { "<Cmd>TestNearest<CR>", "Nearest" },
      s = { "<Cmd>TestSuite<CR>",   "Suite" },
      g = { "<Cmd>TestVisit<CR>",   "Go to test file" },
    },
    Q  = { "<Cmd>qa!<CR>",                 "Force quit all" },
    cc = { "<Plug>NERDCommenterToggle",    "Toggle comment" },
    g  = { "<Cmd>GitGutterToggle<CR>",     "Toggle GitGutter" },
    j  = { "<Cmd>BufferLineCycleNext<CR>", "Next buffer" },
    k  = { "<Cmd>BufferLineCyclePrev<CR>", "Previous buffer" },
    q  = { "<Cmd>q<CR>",                   "Quit" },
    w  = { "<Cmd>w<CR>",                   "Save" },
    wr = { "<Cmd>set wrap!<CR>",           "Toggle wrap" },
    z  = { "<Cmd>Goyo<CR>",                "Zen mode" },
  }
})

-- Visual mode mappings
wk.register(
  {
    ["<leader><space>"] = { "<Plug>(easymotion-prefix)", "Easymotion" },
    ["<leader>cc"]      = { "<Plug>NERDCommenterToggle", "Toggle comment" },
  },
  { mode = "v" }
)
LUA

" Only set language client mappings on filetype with matching language servers
function LC_maps()
  if has_key(g:LanguageClient_serverCommands, &filetype)

    autocmd BufWritePre *.rs,*.go call LanguageClient#textDocument_formatting_sync()

lua << LUA
local wk = require("which-key")

wk.register({
  ["<leader>"] = {
    l = {
      name = "LSP",
      R = { "<Cmd>call LanguageClientRestart()<CR>",                      "Restart LanguageClient" },
      a = { "<Cmd>call LanguageClient#textDocument_codeAction()<CR>",     "Code Actions" },
      b = { "<Cmd>call LanguageClient#textDocument_references()<CR>",     "Find references" },
      c = { "<Cmd>call LanguageClient_handleCodeLensAction()<CR>",        "Code lens" },
      d = { "<Cmd>call LanguageClient#textDocument_definition()<CR>",     "Go to definition" },
      f = { "<Cmd>call LanguageClient#textDocument_formatting()<CR>",     "Format" },
      h = { "<Cmd>call LanguageClient#textDocument_hover()<CR>",          "Hover" },
      i = { "<Cmd>call LanguageClient#textDocument_implementation()<CR>", "Go to implementation" },
      l = { "<Cmd>call LanguageClient_contextMenu()<CR>",                 "Context Menu" },
      r = { "<Cmd>call LanguageClient#textDocument_rename()<CR>",         "Rename" },
      s = { "<Cmd>call LanguageClient#textDocument_documentSymbol()<CR>", "Document symbol" },
      t = { "<Cmd>call LanguageClient#textDocument_typeDefinition()<CR>", "Go to type definition" },
    },
  },
})
LUA
  endif
endfunction
autocmd FileType * call LC_maps()

