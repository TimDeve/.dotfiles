# Ranger
alias rg='ranger'

# NeoVim
alias v='nvim'

# Quick Exit
alias ee='exit'

# Test Connection
alias pingt='ping 8.8.8.8'

# Easy tar.gz
alias tgz='tar -zcvf'
alias untgz='tar -zxvf'

#
# Git Stuff
#

# Git Pretty Tree
alias gtree="git log --oneline --graph --decorate --all"

# Git add + commit
alias gaddcom="git add --all && git commit"

# Git Push
alias gpush="git push"

# Git change last commit message
alias gfixcom="git commit --amend"

# Git status
alias gstat="git status"

# Git diff
alias gdiff="git diff"

#
# End Git Stuff
#

# Tmux
alias tmuxn="tmux new-session -s"
alias tmuxa="tmux attach-session -t"
alias tmuxl="tmux list-sessions"
alias tmuxaa="tmux attach"

alias tmuxad="tmux new -As Default -d"

# ix.io (pastebin like)
alias toixio="curl -F 'f:1=<-' ix.io"

# Speed Test
alias sptest='speedtest-cli --bytes --simple'

# Delete last Command History
alias delhist="sed -i '' -e '$ d' .zhistory"

# copy with a progress bar
alias cpv="rsync -poghb --backup-dir=/tmp/rsync -e /dev/null --progress --"

# List Globally installed npm packages
alias npmlist="npm list -g --depth=0"

# Because you can't remember your aliases
alias whalias="ag '^alias' ~/.dotfiles/zsh --no-numbers"

# Update dot files
alias updot="cd ~/.dotfiles && git add --all && git commit -m 'up' && git push"
alias downdot="cd ~/.dotfiles && git pull"

# Pip Upgrade All Outdated
alias pipupgrade="pip list --outdated | cut -d ' ' -f1 | xargs -n1 pip install -U"

# K with readable file size
alias k="k -h"

# Quick touch
alias t="touch"

# Quick mkdir
alias md="mkdir"
alias mdc="mkcd"
