-- Makes dotfiles modules available
vim.o.runtimepath = vim.o.runtimepath .. ",~/.dotfiles/nvim"

local IS_WORK_MACHINE = os.getenv("IS_WORK_MACHINE") ~= nil
vim.g.IS_WORK_MACHINE = IS_WORK_MACHINE

local utils = require("utils")
local cmd = vim.cmd

vim.opt.autoindent = true
vim.opt.autoread  = true
vim.opt.backspace = "indent,eol,start"
vim.opt.backupcopy = "yes"
vim.opt.clipboard = "unnamed"
vim.opt.cursorline = true
vim.opt.encoding = "utf-8"
vim.opt.expandtab = true
vim.opt.hidden = true
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.incsearch = true
vim.opt.inccommand = "nosplit"
vim.opt.laststatus = 2
vim.opt.linebreak = true
vim.opt.list = true
vim.opt.listchars = "tab:▸ ,trail:▫"
vim.opt.mouse = "a"
vim.opt.number = true
vim.opt.ruler = true
vim.opt.scrolloff = 3
vim.opt.shiftwidth = 2
vim.opt.showbreak = "+++"
vim.opt.showcmd = true
vim.opt.showmatch = true
vim.opt.smartcase = true
vim.opt.softtabstop = 2
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.tabstop = 2
vim.opt.termguicolors = true
vim.opt.timeoutlen = 500
vim.opt.undofile = true
vim.opt.undolevels = 1000
vim.opt.undoreload = 10000
vim.opt.visualbell = true
vim.opt.wildignore = "log/**,node_modules/**,target/**,tmp/**,*.rbc"
vim.opt.wildmenu = true
vim.opt.wildmode = "full"

cmd [[
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

autocmd FileType gitconfig set noexpandtab

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
map <space> <leader>

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

command GitLastMessage r ! git log -1 --pretty=format:\%B
]]

if IS_WORK_MACHINE then
  vim.g.python3_host_prog = '/usr/bin/python3'
  vim.g.python_host_prog = '/usr/bin/python'
end

-- Use cross platform clipboard if on WSL
if vim.fn.system('uname -a | egrep [Mm]icrosoft') ~= "" then
  if utils.has_exe('win32yank.exe') then
    table.insert(vim.opt.clipboard, "unnamedplus")
    vim.g.clipboard = {
      name = 'win32yank-wsl',
      copy = {
         ['+'] = 'win32yank.exe -i --crlf',
         ['*'] = 'win32yank.exe -i --crlf',
       },
      paste = {
         ['+'] = 'win32yank.exe -o --lf',
         ['*'] = 'win32yank.exe -o --lf',
      },
      cache_enabled = 0,
    }
  end
end

-- Load plugins
cmd [[ source ~/.dotfiles/nvim/vim/plug.vim ]]

---- Plug Conf

-- Source other config files
utils.setup_all({"mappings", "lsp", "line"})

cmd [[silent colorscheme gruvbox8_hard]]

-- NerdCommenter
vim.g.NERDDefaultAlign = 'left'
vim.g.NERDCommentEmptyLines = 1
vim.g.NERDCreateDefaultMappings = 0
vim.g.NERDCustomDelimiters = { carp = { left = ";" } }

if utils.has_exe('rg') then
  vim.opt.grepprg = "rg --color=never"

  -- Use ripgrep with fzf
  vim.g.FZF_DEFAULT_COMMAND = 'rg --files --hidden'
end

-- Disable sexp default for leader w
vim.g.sexp_mappings = { sexp_round_head_wrap_element = "" }

-- GitGutter
vim.opt.updatetime = 250

-- Deoplete
cmd [[
let g:deoplete#enable_at_startup = 1
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif
autocmd FileType TelescopePrompt call deoplete#custom#buffer_option('auto_complete', v:false)

" deoplete tab-complete
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
inoremap <expr><S-tab> pumvisible() ? "\<c-p>" : "\<S-tab>"
inoremap <expr><CR> pumvisible() ? "\<c-y>" : "\<CR>"
]]

-- Activate Rainbow parens only for Lisps
vim.g.rainbow_active = 0
cmd [[autocmd FileType clojure,carp :RainbowToggleOn]]

-- Vim-Go
vim.g.go_fmt_command = "goimports"

-- vim-move
vim.g.move_key_modifier = 'S'

-- Goyo
cmd [[
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
]]

-- vim-test
if vim.g.is_in_tmux then
  vim.g["test#strategy"] = "vimux"
else
  vim.g["test#strategy"] = "neovim"
end

if utils.has_exe('richgo') then
  vim.g["test#go#runner"] = "richgo"
end

-- Rust
vim.g.rustfmt_autosave = 1
vim.g.syntastic_rust_checkers = {}

-- vim-todo
vim.g.VimTodoListsMoveItems = 0

-- Carp
vim.g.syntastic_carp_checkers = {'carp'}

-- Markdown
vim.g.vim_markdown_folding_disabled = 1
vim.g.vim_markdown_new_list_item_indent = 0
vim.g.vim_markdown_frontmatter = 1

-- Extra shebang detection
cmd [[
AddShebangPattern! clojure ^#!.*/bin/env\s\+bb\>
AddShebangPattern! typescript ^#!.*/bin/env\s\+deno.*\>
AddShebangPattern! typescript ^#!.*/bin/env\s-S\sdeno.*\>
]]

-- Leap
require('leap').set_default_keymaps()

-- Bufferline
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

-- nvim-tree
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

-- Telescope
require('telescope').setup{
  defaults = {
    mappings = {
      n = {
        ["k"] = require('telescope.actions').cycle_history_prev,
        ["j"] = require('telescope.actions').cycle_history_next,
      }
    },
  },
}

-- Treesitter
local treesitter_langs = {
  "bash", "c", "cpp", "go", "javascript", "json", "lua", "make", "markdown",
  "markdown_inline", "python", "regex", "rust", "sql", "hcl", "toml", "tsx",
  "typescript", "yaml",
}
for _, lang in ipairs(treesitter_langs) do
  treesitter_langs[lang] = true
end

local treesitter_settings = {
  highlight = {
    enable = true,
    disable = function(lang) return treesitter_langs[lang] ~= true end,
  },
}

if utils.has_exe("tree-sitter") then
  treesitter_settings.ensure_installed = treesitter_langs
end

require('nvim-treesitter.configs').setup(treesitter_settings)

require('treesitter-context').setup({
  patterns = {
    go = {
      'function_declaration',
    },
  },
})

-- dressing.nvim (Nicer inputs)
require("dressing").setup{}

-- trouble (Diagnostic window)
require("trouble").setup {
  icons = false,
  fold_open = "v",
  fold_closed = ">",
  indent_lines = false,
  use_diagnostic_signs = true
}

-- vim-visual-multi
vim.g["VM_set_statusline"] = 0 -- Disable status line, use lualine instead
vim.g["VM_silent_exit"] = 1
vim.g["VM_show_warnings"] = 0
