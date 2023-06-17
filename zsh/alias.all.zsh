# Shorter editors
alias v='nvim'
alias vs="v +SessionLoad"
alias vi='nvim -u ~/.dotfiles/nvim/bare.vim'
alias suv='sudo "$(which nvim)" -u "$HOME/.dotfiles/nvim/bare.vim"'

# Quick Exit
alias ee='exit'

# Test Connection
alias pingt='ping 8.8.8.8'
alias spingt='sping 8.8.8.8'

# Easy tar
alias tgz='tar -zcvf'
alias txz='tar -Jcvf'
alias tzz="zip -r"
alias untar='tar -xvf'

# Expand aliases when calling sudo
alias sudo='nocorrect sudo '

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
alias gswi="git switch"
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
alias gaddupstream="git remote add upstream"
alias glog="git log --pretty=format:'%C(yellow)%h %Cred%ad %Cblue%an %Creset%s' --date=iso"

alias ghpush="gh repo create && gpushf"
alias ghclone="gh repo clone \$(gh repo list --limit 9999 | awk '{print \$1}' | fzf)"

alias lg="lazygit"

if [[ -f $(which delta) ]]; then
  # Git diff
  alias gdiff="git diff | delta --paging=never --keep-plus-minus-markers"

  # Git diff HEAD and origin
  alias gdifff="git diff HEAD...origin | delta --paging=never --keep-plus-minus-markers"
else
  # Git diff
  alias gdiff="git diff --color"

  # Git diff HEAD and origin
  alias gdifff="git diff HEAD...origin"
fi

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
alias tmuxad="tmux attach-session -d -t Default || tmux new-session -s Default"

# Speed Test
alias sptest='speedtest-cli --bytes --simple'

# Delete last Command History
alias delhist="sed -i'' -e '$ d' ~/.zhistory"

# copy with a progress bar
alias cpv="rsync -poghb --backup-dir=/tmp/rsync -e /dev/null --progress --"

# List Globally installed npm packages
alias npmlist="npm list -g --depth=0"

# Pip Upgrade All Outdated
alias pipupgrade="pip list --outdated | cut -d ' ' -f1 | xargs -n1 pip install -U"

# Quick touch
alias t="touch"

# Quick mkdir
alias md="mkdir"
alias mdc="mkcd"

# Simple Python Server
alias pyserv="python -m SimpleHTTPServer"

# Peerflix
alias pf="peerflix -k"

alias strm="streamlink -p mpv --default-stream best"

# Docker
alias dk="docker"
alias dkc="docker compose"

alias dkrt="dk run -it --rm"

# Whats my IP
alias whatsmyip="dig +short myip.opendns.com @resolver1.opendns.com"

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

# PNPM
alias pn="pnpm"
alias pni="pnpm install"
alias pna="pnpm add"
alias pnad="pnpm add --save-dev"
alias pnag="pnpm add -g"
alias pnd="pnpm remove"
alias pndg="pnpm remove -g"
alias pnr="pnpm run"
alias pns="pnpm start"
alias pnt="pnpm test"
alias pnx="pnpx"

# Notes
alias nn="not"
alias ns="not -s"

alias epoch="date +'%s'"

# Select which package you want to update on npm
alias ncus="ncu | fzf -m | awk '{ print $1 }' | xargs -0 -n1 ncu -u"

alias rgf="rg -F"

alias tunn="npx localtunnel --local-host localhost"

alias mk="make"
alias mkx="make.exe"
alias cmk="cmake"

alias get="aria2c -x2"
alias rsy="rsync -Paz"

alias bbrepl="rlwrap bb"

alias ls="ls --color=auto --group-directories-first --color=auto"
if hash exa 1>/dev/null 2>/dev/null; then
  exa_grey="38;5;241"
  exa_filesize_numbers="sn=$exa_grey"
  exa_filesize_unit="sb=$exa_grey"
  exa_my_user="uu=$exa_grey"
  exa_date="da=$exa_grey"
  export EXA_COLORS="${exa_filesize_numbers}:${exa_filesize_unit}:${exa_my_user}:${exa_date}:${exa_exec_file}"

  alias l="exa -1a --group-directories-first"
  alias ll="exa -l --git --group-directories-first"
  alias la="ll -a"
  alias lal="exa -l --git -snew -a "
  alias lll="exa -l --git -snew"
else
  alias la="ll -A"
  alias ll="ls -lh"
  alias lal="la -tr"
  alias lll="ll -tr"
fi

alias each="xargs -n 1"
alias each-line="xargs -n 1 -d $'\n'"

alias caddy-serve="caddy file-server --listen :2015 --browse"

# k8s
alias k="kubectl"
alias kuse='k config use-context $(k config get-contexts -o name | fzf)'
alias kl="k logs"
alias klf="kl -f"
alias h="helm"

# Signal
alias sigint="kill -2"
alias sigquit="kill -3"
alias sigkill="kill -9"
alias sigterm="kill -15"

# Frawk
alias fk="frawk"
alias fks="frawk -i csv -o csv"
alias fkt="frawk -i tsv -o tsv"

alias rt="read-that"

alias xhc="xh --session /tmp/xh-cookie-jar"
alias xhsc="xhs --session /tmp/xh-cookie-jar"
alias xhc-clear="rm -f /tmp/xh-cookie-jar"

alias ru="ruplacer"

alias teer="tee >(cat 1>&2)"
