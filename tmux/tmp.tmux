source-file "$DOTFILES/tmux/tmux.conf"

# ------------------------------
# Initialise Tmux Plugin Manager
# ------------------------------
# List of plugins
set -g @plugin 'Morantron/tmux-fingers'
set -g @plugin 'nhdaly/tmux-scroll-copy-mode'
set -g @plugin 'tmux-plugins/tmux-copycat'
set -g @plugin 'tmux-plugins/tmux-open'
set -g @plugin 'tmux-plugins/tmux-resurrect'
set -g @plugin 'tmux-plugins/tmux-continuum'
set -g @plugin 'tmux-plugins/tmux-sensible'
set -g @plugin 'tmux-plugins/tmux-sidebar'
set -g @plugin 'tmux-plugins/tmux-yank'
set -g @plugin 'tmux-plugins/tpm'

set -g @resurrect-strategy-nvim 'session'
set -g @resurrect-processes 'btop "~nvim->v +SessionLoad"'
set -g @continuum-restore 'on'
set -g @continuum-save-interval '10'

# Fixes exit on copy mode on select
set -g @yank_action 'copy-pipe'
set -g @yank_with_mouse off

# Initialize TMUX plugin manager (keep this line at the very bottom of tmux.conf)
run '~/.tmux/plugins/tpm/tpm'

