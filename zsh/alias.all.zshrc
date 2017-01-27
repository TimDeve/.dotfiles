# Ranger
alias rg='ranger'

# NeoVim
alias v='nvim'

# Quick Exit
alias ee='exit'

# Test Connection
alias pingt='ping 8.8.8.8'

# Easy tar
alias tgz='tar -zcvf'
alias txz='tar -Jcvf'
alias tzz="zip -r"
alias untar='tar -xvf'

#
# Git Stuff
#

alias gcom="git commit"
alias gadd="git add"
alias gaddcom="git add -u && git commit"
alias gadddcom="git add --all && git commit"
alias gpush="git push"
alias gpull="git pull"
alias gstat="git status"
alias gchek="git checkout"
alias gmerg="git merge"
alias ginit="git init"
alias gfech="git fetch"

# Git diff
alias gdiff="git diff --color"

# Git diff HEAD and origin
alias gdifff="git diff HEAD...origin"

# Git Pretty Tree
alias gtree="git log --oneline --graph --decorate --all"

# Git fix last commit (wrong commit message, forgot to git add...)
alias gfixcom="git commit --amend"

# Git Deletes all local branch merged into master
alias gdelmerged='git branch --merged | grep -v "\*" | grep -v master | grep -v dev | grep -v production | xargs -n 1 git branch -d'

# cd to root of repo
alias cg='cd "$(git rev-parse --show-toplevel)"'

#
# End Git Stuff
#

# Tmux
alias tmuxn="tmux new-session -s"
alias tmuxa="tmux attach-session -t"
alias tmuxl="tmux list-sessions"
alias tmuxaa="tmux attach"
alias tmuxad="tmux attach-session -t Default || tmux new-session -s Default"
alias tmuxav="tmux attach-session -t Vim || tmux new-session -s Vim"

# ix.io (pastebin like)
alias toixio="curl -F 'f:1=<-' ix.io"

# Speed Test
alias sptest='speedtest-cli --bytes --simple'

# Delete last Command History
alias delhist="sed -i'' -e '$ d' ~/.zhistory"

# copy with a progress bar
alias cpv="rsync -poghb --backup-dir=/tmp/rsync -e /dev/null --progress --"

# List Globally installed npm packages
alias npmlist="npm list -g --depth=0"

# Because you can't remember your aliases
alias whalias="ag '^alias' ~/.dotfiles/zsh --no-numbers -B 1"

# Update dot files
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

# Reload zshrc
alias zreload="source ~/.zshrc"

# Pokemon color script
alias poke="bash ~/.dotfiles/scripts/general/c-poke"

# Simple Python Server
alias pyserv="python -m SimpleHTTPServer"

# Make a new github repo here
alias gn="gitnew timdeve"

# Peerflix
alias pf="peerflix -k"

# Livestreamer
alias lst="livestreamer -p mpv"

# Docker
alias dk="docker"

# Shorter subl
alias s="subl"

# Allows to run sudo on aliases
# alias sudo="sudo "

# Trash
alias th="trash"

# Whats my IP
alias whatsmyip="dig +short myip.opendns.com @resolver1.opendns.com"

# Folder size
alias wh="du -sh"

# Forgot sudo
alias pls='sudo $(fc -ln -1)'
