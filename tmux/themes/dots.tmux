# panes
set -g pane-border-style fg=colour235
set -g pane-active-border-style fg=colour238

# toggle statusbar
bind-key b set-option status

# status line
set -g status-justify left
set -g status-style bg=default,fg=default
set -g status-interval 2

# messaging
set -g message-style fg=black,bg=yellow
set -g message-command-style fg=blue,bg=black
set -g automatic-rename on

# window mode
setw -g mode-style bg=colour6,fg=colour0

# colors
setw -g window-status-format "#[fg=colour3] •#[fg=colour248] #W "
setw -g window-status-current-format "#{?#{==:#F,*Z},#[fg=colour4],#[fg=colour2]} •#[fg=colour7] #W "
set -g status-position bottom
set -g status-justify centre
set -g status-left "  #[fg=colour3]• #[fg=colour2]• #[fg=colour4]•"
set -g status-right " #[fg=colour4] •#[fg=colour7] #S  "
