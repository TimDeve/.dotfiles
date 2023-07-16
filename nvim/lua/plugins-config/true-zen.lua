local utils = require("utils")

local M = {}

M.cmd = {"TZNarrow", "TZFocus", "TZMinimalist", "TZAtaraxis"}

function M.setup()
  require("true-zen").setup {
    modes = {
      ataraxis = {
        shade = "dark", -- if `dark` then dim the padding windows, otherwise if it's `light` it'll brighten said windows
        backdrop = 0, -- percentage by which padding windows should be dimmed/brightened. Must be a number between 0 and 1. Set to 0 to keep the same background color
        minimum_writing_area = { -- minimum size of main window
          width = 100,
          height = 44,
        },
        quit_untoggles = true, -- type :q or :qa to quit Ataraxis mode
        padding = { -- padding windows
          left = 999,
          right = 999,
          top = 3,
          bottom = 3,
        },
        callbacks = { -- run functions when opening/closing Ataraxis mode
          open_pre = utils.cmd_cb [[
            if g:is_in_tmux
              silent !tmux set status off
              silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
            endif

            set noshowmode
            set noshowcmd
            set scrolloff=999

            Lazy load vim-monotone
            Lazy load limelight.vim
            silent colorscheme monotone
            Monotone 0 0 70 0 0 0 0.785
            Limelight
          ]],
          open_pos = nil,
          close_pre = utils.cmd_cb [[
            if g:is_in_tmux
              silent !tmux set status on
              silent !tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z
            endif

            set showmode
            set showcmd
            set scrolloff=3

            silent colorscheme gruvbox
            Limelight!
          ]],
          close_pos = M.gruvbox
        },
      },
    },
    integrations = {
      lualine = true -- hide nvim-lualine (ataraxis)
    },
  }
end

return M

