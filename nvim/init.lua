-- Makes dotfiles modules available
custom_runtimepath = vim.fn.expand("~/.dotfiles/nvim")
vim.opt.rtp:prepend(custom_runtimepath)

local IS_WORK_MACHINE = os.getenv("IS_WORK_MACHINE") ~= nil
vim.g.IS_WORK_MACHINE = IS_WORK_MACHINE

local utils = require("utils")
local autocmd = utils.autocmd
local highlight = utils.highlight
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

highlight("StatusLine", { ctermfg = 234,     ctermbg = 238 })
highlight("WildMenu",   { ctermfg = "white", ctermbg = 27 })

-- Turns on spellcheck for git commits and markdown
autocmd("FileType", {"gitcommit", "markdown"}, "setlocal spell")

-- zshrc is zsh
autocmd({"BufRead", "BufNewFile"}, "*.zshrc", "setlocal filetype=zsh")

-- tsx is tsx :)
autocmd({"BufRead", "BufNewFile"}, "*.tsx", "setlocal filetype=typescript.tsx")

-- bats is bash
autocmd({"BufRead", "BufNewFile"}, "*.bats", "setlocal filetype=bash")

-- todo is todo
autocmd({"BufRead", "BufNewFile"}, "*.todo", "setlocal filetype=todo")

-- carp is carp
autocmd({"BufRead", "BufNewFile"}, "*.carp", "setlocal filetype=carp")

-- Use tabs with go, gitconfig
autocmd("FileType", {"go", "gitconfig"}, "set noexpandtab")

-- Automatically rebalance windows on vim resize
autocmd("VimResized", "*", "wincmd =")

-- Fallback colorscheme
cmd "silent colorscheme pablo"

-- Check if we're running in tmux
vim.g.is_in_tmux = utils.has_exe("tmux") and os.getenv("TMUX") ~= nil

-- Use space as leader
cmd "map <space> <leader>"

-- Use kj as Escape
cmd "inoremap kj <esc>"

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

-- Setup lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load basic bindings
cmd "source ~/.dotfiles/nvim/vim/basic-bindings.vim"

-- Load plugins lazily
require("plugins").setup({ runtimepath = custom_runtimepath })

-- [Plug Conf] --

-- Source other config files
utils.setup_all({"bindings", "lsp", "line"})

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

-- Vim-Go
vim.g.go_fmt_command = "goimports"

-- vim-move (Disable default bindings)
vim.g.move_map_keys = 0

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

  lua require("lualine").hide()
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

  lua setup_bufferline()

  lua require("lualine").hide { unhide = true }
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
function setup_bufferline()
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
end
setup_bufferline()

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
