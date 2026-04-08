# Theme: Gray (Local/Default)
set -g @gray_border_in  'colour235'
set -g @gray_border_ac  'colour238'
set -g @gray_status_bg  'colour236'
set -g @gray_status_fg  'colour246'
set -g @gray_active_bg  'colour239'
set -g @gray_active_fg  'colour249'
set -g @gray_dim        'colour242'

# Theme: Purple (SSH Active)
set -g @purple_bg       '#432a4a'
set -g @purple_accent   '#cc88db'
set -g @purple_low      '#2e1d33'
set -g @purple_fg       '#f8f2f9'

# Theme: Alerts & Modes
set -g @zoom_bg         '#ff5555'
set -g @zoom_fg         '#000000'
set -g @warn_bg         'yellow'
set -g @warn_fg         'black'
set -g @mode_bg         'colour6'
set -g @mode_fg         'colour0'

set -g status-justify centre
set -g status-position bottom
set -g status-style bg=default,fg=default
set -g status-interval 2
set-window-option -g window-status-separator ''

set -g pane-border-style "#{?SSH_TTY,fg=#{@gray_border_ac},fg=#{@gray_border_in}}"
set -g pane-active-border-style "#{?SSH_TTY,fg=#{@purple_bg},fg=#{@gray_border_ac}}"

setw -g window-status-current-format "#{?#{==:#F,*Z},#[fg=#{@zoom_fg}]#[bg=#{@zoom_bg}],#{?SSH_TTY,#[fg=#{@purple_fg}]#[bg=#{@purple_bg}],#[fg=#{@gray_active_fg}]#[bg=#{@gray_active_bg}]}}    #W    "
setw -g window-status-format "#{?SSH_TTY,#[fg=#{@purple_fg}]#[bg=#{@purple_low}],#[fg=#{@gray_status_fg}]#[bg=#{@gray_status_bg}]}    #W    "

set -g status-left "#{?SSH_TTY,#[fg=#{@purple_accent}] ──── #(hostname -s),#[fg=#{@gray_dim}] ──── Tmux} "
set -g status-right "#{?SSH_TTY,#[fg=#{@purple_accent}],#[fg=#{@gray_dim}]} #S ──── "

set -g message-style "#{?SSH_TTY,fg=#{@purple_fg} bg=#{@purple_bg},fg=#{@warn_fg} bg=#{@warn_bg}}"
setw -g mode-style "#{?SSH_TTY,fg=#{@purple_fg} bg=#{@purple_bg},fg=#{@mode_fg} bg=#{@mode_bg}}"

# Toggle statusbar
bind-key b set-option status
