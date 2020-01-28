# Shorter editors
alias v='nvim'
alias s='subl'
alias c='code'

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

alias gcom="git commit --verbose"
alias gadd="git add"
alias gaddcom="git add -u && git commit --verbose"
alias gadddcom="git add --all && git commit --verbose"
alias gpush="git push --follow-tags"
alias gpull="git pull"
alias gpullr="git pull --rebase"
alias gstat="git status"
alias gchek="git checkout"
alias gchekb="git checkout -b"
alias gmerg="git merge"
alias ginit="git init"
alias gfech="git fetch"
alias gclon="git clone"
alias gclean="git clean"
alias gclin="git clean -i"
alias gsta="git stash"
alias gstap="git stash pop"
alias gstad="git stash drop"
alias greba="git rebase"
alias grebac="git rebase --continue"

# Git diff
alias gdiff="git diff --color"

# Git diff HEAD and origin
alias gdifff="git diff HEAD...origin"

# Git Pretty Tree
alias gtree="git log --oneline --graph --decorate --all"

# Git fix last commit (wrong commit message, forgot to git add...)
alias gfixcom="git commit --amend"
alias gfixcomq="git commit --amend --no-edit"

# Git Deletes all local branch merged into master
alias gdelmerged='git branch --merged | grep -v "\*" | grep -v master | grep -v dev | grep -v production | xargs -n 1 git branch -d'

# cd to root of repo
alias cg='cd "$(git rev-parse --show-toplevel)"'

#
# End Git Stuff
#

# Tmux
alias tmuxn="tmux new-session -s"
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
alias dkc="docker-compose"

# Trash
alias th="trash"

# Whats my IP
alias whatsmyip="dig +short myip.opendns.com @resolver1.opendns.com"

# Folder size
alias wh="du -sh"

# Forgot sudo
alias pls='sudo $(fc -ln -1)'

# Tree without annoying folder
alias tre="tree -I node_modules"

# AWS S3
alias ss="aws s3"
alias sscp="aws s3 cp"
alias ssmv="aws s3 mv"
alias ssrm="aws s3 rm"
alias ssls="aws s3 ls"

# NPM
alias npi="npm install"
alias npa="npm install --save"
alias npad="npm install --save-dev"
alias npag="npm install -g"
alias npd="npm uninstall --save"
alias npdg="npm uninstall -g"
alias npr="npm run"
alias nps="npm start"
alias npt="npm test"

# Exa (ls improved)
alias h="exa -gHl --git"
alias ha="exa -gHla --git"
alias lh="exa -gHl --git --sort=modified"
alias lha="exa -gHla --git --sort=modified"

# Fasd
alias f="fasd_cd -d"
alias fo="fasd -e"
alias fv="fasd -e nvim"
alias fc="fasd -e code"

# Notes
alias nn="not"
alias ns="not -s"

# Rake
alias rk="rake"

# Nix
alias nxe="nix-env"
alias nxi="nix-env -i"
alias nxr="nix-env -e"
alias nxu="nix-env -u"
alias nxs="nix-channel --update"

alias epoch="date +'%s'"

