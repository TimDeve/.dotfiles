-- Makes dotfiles modules available
local custom_runtimepath = vim.fn.expand("~/.dotfiles/nvim")
vim.opt.rtp:prepend(custom_runtimepath)

local utils = require("utils")
local autocmd = utils.autocmd
local highlight = utils.highlight

vim.opt.autoindent = true
vim.opt.autoread  = true
vim.opt.backspace = "indent,eol,start"
vim.opt.backupcopy = "yes"
vim.opt.clipboard = {"unnamed", "unnamedplus"}
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

local match_filetype = {
  {"*.zshrc", "zsh"},
  {"*.tsx",   "typescript.tsx"},
  {"*.bats",  "bash"},
  {"*.todo",  "todo"},
  {"*.carp",  "carp"},

  -- Go stuff
  {"*.go",    "go"},
  {"*.tmpl",  "gohtmltmpl"},
  {"go.work", "gowork"},
  {{"go.sum", "go.work.sum"}, "gosum"},
}
if utils.IS_WORK_MACHINE then table.insert(match_filetype, {"BUILD", "please"}) end
utils.match_filetype(match_filetype)

-- Use tabs with go, gitconfig
autocmd("FileType", {"go", "gitconfig"}, "set noexpandtab")

-- Automatically rebalance windows on vim resize
autocmd("VimResized", "*", "wincmd =")

-- Fallback colorscheme
vim.cmd "silent colorscheme pablo"

-- Check if we're running in tmux
vim.g.is_in_tmux = utils.has_exe("tmux") and os.getenv("TMUX") ~= nil

-- Use space as leader
vim.cmd "map <space> <leader>"

-- Use kj as Escape
vim.cmd "inoremap kj <esc>"

if utils.IS_WORK_MACHINE then
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
vim.cmd "source ~/.dotfiles/nvim/vim/basic-bindings.vim"

require("commands")

-- Load plugins lazily
require("plugins").setup({ runtimepath = custom_runtimepath })

-- Setup startup plugins config
require("config-init").setup()

