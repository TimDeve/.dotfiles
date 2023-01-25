local utils = require("utils")

local M = {}

function M.setup()
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
  vim.cmd [[
  autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif
  autocmd FileType TelescopePrompt call deoplete#custom#buffer_option('auto_complete', v:false)

  " deoplete tab-complete
  inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
  inoremap <expr><S-tab> pumvisible() ? "\<c-p>" : "\<S-tab>"
  inoremap <expr><CR> pumvisible() ? "\<c-y>" : "\<CR>"
  ]]

  -- vim-move (Disable default bindings)
  vim.g.move_map_keys = 0

  -- Goyo
  vim.cmd [[
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

  -- vim-todo
  vim.g.VimTodoListsMoveItems = 0

  -- Carp
  vim.g.syntastic_carp_checkers = {'carp'}

  -- Markdown
  vim.g.vim_markdown_folding_disabled = 1
  vim.g.vim_markdown_new_list_item_indent = 0
  vim.g.vim_markdown_frontmatter = 1

  -- Extra shebang detection
  vim.cmd [[
  AddShebangPattern! clojure ^#!.*/bin/env\s\+bb\>
  AddShebangPattern! typescript ^#!.*/bin/env\s\+deno.*\>
  AddShebangPattern! typescript ^#!.*/bin/env\s-S\sdeno.*\>
  ]]

  -- vim-visual-multi
  vim.g["VM_set_statusline"] = 0 -- Disable status line, use lualine instead
  vim.g["VM_silent_exit"] = 1
  vim.g["VM_show_warnings"] = 0
end

return M
