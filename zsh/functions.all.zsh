errcho() { echo "$@" 1>&2 }

# Mkdir and cd
mkcd() { mkdir -p "$@" && cd "$_"; }

sdb() { mkcd "$HOME/dev/sandbox/$1" }

# Upload file to transfert.sh
transfer() {
  if [ $# -eq 0 ];
    then echo "No arguments specified. Usage:\necho transfer /tmp/test.md\ncat /tmp/test.md | transfer test.md";
    return 1;
  fi;
  tmpfile=$( mktemp -t transferXXX );
  if tty -s; then basefile=$(basename "$1" | sed -e 's/[^a-zA-Z0-9._-]/-/g');
    curl --progress-bar --upload-file "$1" "https://transfer.sh/$basefile" >> $tmpfile;
    else curl --progress-bar --upload-file "-" "https://transfer.sh/$1" >> $tmpfile;
  fi;
  cat $tmpfile;
  rm -f $tmpfile;
}

gi() { curl -L -s "https://www.gitignore.io/api/$@" }

weather(){ curl "http://wttr.in/$1" }

up() {
  local x='';
  for i in $(seq ${1:-1}); do
    x="$x../"
  done
  cd $x
}

countstr() {
  local mystring=$@
  echo "${#mystring}"
}

gfechm() { erropts
  local default_branch; default_branch=$(basename $(git symbolic-ref --short refs/remotes/origin/HEAD))
  git fetch origin "$default_branch:$default_branch"
}

grebam() { erropts
  local default_branch; default_branch=$(basename $(git symbolic-ref --short refs/remotes/origin/HEAD))
  git rebase "$default_branch"
}

gdrop() {
  if yorn "Discard all changes?"; then
    git add --all && git stash && git stash drop
  fi
}

guncom() {
  if yorn "Uncommit latest changes?"; then
    git reset HEAD~
  fi
}

gdelcom() {
  if yorn "\x1b[2;37m> $(git log --pretty=format:%s | head -n1)\n\x1b[0mDelete latest commit?"; then
    git reset HEAD~ --hard
  fi
}

gdelbi() {
  setopt local_options UNSET ERR_RETURN
  local branches
  branches=$(git branch | awk '/.* master$/{next} /\* .*/{next} {print $1}' | fzf --multi --reverse)
  if yorn "Are you sure you want to delete these branches?" "$branches"; then
    <<< "$branches" xargs git branch -D
  fi
}

gdifs() {
  if hash delta 1>&2 2>/dev/null; then
    git --no-pager diff | delta --paging=never --keep-plus-minus-markers
  else
    git --no-pager diff --color
  fi
  printf '─%.0s' {1..$COLUMNS} && echo
  printf '─%.0s' {1..$COLUMNS} && echo
  git status
}

gclonorg() {
  local org=$1 tfa=$2 
  while read -r repo
    do git clone $repo
  done <<< $(curl -H "X-GitHub-OTP: $tfa" -u timdeve -s "https://api.github.com/orgs/$org/repos?per_page=200" | jq -r ".[].ssh_url")
}

gpushu() {
  git push --set-upstream origin $(git rev-parse --abbrev-ref HEAD)
}

gfindcom() {
  git log  | rg "$*" -C 3
}

gcomsincet() {
  git log $1..HEAD --oneline
}

grebai() { erropts
  local commit="" fmt="%C(3)%h %C(4)%>(12)%ad %C(5)%<(8,trunc)%an %Creset%s"
  commit=$(git log --pretty=format:"$fmt" --date=relative --color=always \
    | fzf --ansi \
    | cut -d ' ' -f1)
  git rebase -i "$commit"
}

gtagi() {
  git checkout $(git tag | fzf)
}

hometotilde() {
  sed -E "s|^$HOME|~|g"
}

gswp() { erropts
  local is_worktree=0
  local branch; branch="$(git branch --sort=-committerdate | fzf -1 -q "$*")"
  [[ "$branch" =~ '^\+.*' ]] || is_worktree=$?
  branch="$(<<< "$branch" sed -Ee 's/^(\*|\s|\+)\s//')"
  if (exit $is_worktree); then
    local wt_path; wt_path="$(git worktree list --porcelain | rg -B 2 "^branch refs/heads/$branch" | sed -En 's/worktree (.*)/\1/p')"
    yorn "Switch to workspace at '$(<<< "$wt_path" hometotilde)'?"
    cd "$wt_path"
  else
    gswi "$branch"
  fi
}

n() {
  if [[ "${NNNLVL:-0}" -ge 1 ]]; then
    echo "nnn is already running"
    return
  fi

  local lastDir=${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd

  \nnn -de "$@"

  if [ -f "$lastDir" ]; then
    . "$lastDir"
    rm -f "$lastDir"
  fi
}

# Quick Notes
nq() {
  not -q "$*"
}

nt() {
  not -t "$*"
}

# Count line in given folder
countln() {
  local folder="$1"
  if [ -z $folder ]
  then
    folder="."
  fi
  find $folder -type f | xargs wc -l
}

yorn() {
  local question="$1" answer extra

  if ! [[ -z "${2-}" ]]; then
    extra="\n$2"
  fi

  echo "$question (y/N)$extra"

  read -sk answer
  if [ $answer = y ]; then
    return 0
  else
    return 1
  fi
}

poll() {
  local sleepTime=$1
  shift

  while true; do
    eval $@
    sleep $sleepTime
  done
}

pollf() { erropts
  local sleepTime=$1
  shift

  while true; do
    eval $@
    sleep $sleepTime
  done
}

pollt() {
  local sleepTime=$1
  shift

  while true; do
    eval $@ && return
    sleep $sleepTime
  done
}

tillrg() {
  local pattern=$1
  shift

  while true; do
    eval $@ | rg "$pattern" && break
    sleep 0.01
  done
  ntfy publish "$NTFY_DEFAULT" "'$1' is done!"
}

tmuxa() {
  tmux attach-session -d -t $@ || tmux new-session -s $@
}

carpw() {
  npx nodemon -e carp,h -x "carp -x $* || exit 1"
}

carpwc() {
  npx nodemon -e carp,h -x "carp --check $* || exit 1"
}

carpwb() {
  npx nodemon -e carp,h -x "carp -b $* || exit 1"
}

carpwsan() {
  npx nodemon -e carp,h -x "carp -x --log-memory --eval-postload '(Debug.sanitize-addresses)' $* || exit 1"
}


rgff() {
  rgf --no-heading --color=always -n $@ | fzf --ansi
}

rgfv() {
  local selection=$(rgff $@)

  if [[ -z $selection ]]; then
    return
  fi

  nvim +$(echo $selection | cut -d ':' -f 2) $(echo $selection | cut -d ':' -f 1)
}

scarp() {
  if [[ -z "$@" ]]; then
    local selection=$(cd $CARP_DIR/docs/core && ls -1A | rg html | fzf)

    if [[ -z $selection ]]; then
      return
    fi

    w3m "$CARP_DIR/docs/core/$selection"
  else
    local selection=$(cd $CARP_DIR/docs && rgff $@)

    if [[ -z $selection ]]; then
      return
    fi

    w3m "$CARP_DIR/docs/$(echo $selection | cut -d ':' -f 1)"
  fi
}

scarps() {
  local wd=$PWD
  cd $CARP_DIR \
    && rgfv $@
  cd $wd
}

video2gif() {
  if [[ -z "$1" ]]; then
    errcho "Needs input video file"
    return 1
  fi

  local out
  if [[ -z "$2" ]]; then
    out="${1}.gif"
  else
    out="$2"
  fi

  ffmpeg -i "$1" -vf "fps=10,scale=320:-1:flags=lanczos" \
         -c:v pam -f image2pipe - \
         | convert -delay 10 - -loop 0 -layers optimize "$out"
}

if alias d &>/dev/null; then unalias d; fi
d() {
  local dir
  dir="$(dirs -v | fzf)"
  if [[ ! -z "$dir" ]]; then
    cd "+$(echo $dir | awk '{ print $1 }')"
  fi
}

tre() {
  rg --files $@ | tree --fromfile
}

bytelen() {
  stat "$@" | awk '{ print $8 "bytes" }'
}

fixdotssh() {
  chmod 700 ~/.ssh
  chmod 600 ~/.ssh/*
  chmod 644 ~/.ssh/*.pub
}

dokku() {
  ssh dokkudk "dokku $@"
}

# Avoids clashes between sd (search and replace) and sd (script manager)
sdr() {
  local sd_path bin_name
  bin_name="sd"
  sd_path=$(whence -p "$bin_name")
  if [[ -z "$sd_path" ]]; then
    echo "zsh: command not found: $bin_name"
  else
    "$sd_path" "$@"
  fi
}

dot() {
  local print_usage=false
  local exit_code=0

  case "${1-}" in
    "")
      cd $DOTFILES
      ;;
    "up")
      (cd $DOTFILES \
        && git add -u \
        && git commit --verbose \
        && git push)
      exit_code=$?
      ;;
    "down")
      (cd $DOTFILES && git pull --rebase)
      exit_code=$?
      ;;
    "-h")
      print_usage=true
      ;;
    *)
      errcho "Unknow command '$@'"
      errcho
      print_usage=true
      exit_code=1
      ;;
  esac

  if [ $print_usage = true ]; then
      errcho "USAGE:"
      errcho "    \"\""
      errcho "        cd to dotfiles folder"
      errcho "    up"
      errcho "        commit and push existing files in dotfiles folder"
      errcho "    down"
      errcho "        pull dotfiles from remote"
      errcho "    -h"
      errcho "        prints this message"
  fi

  return exit_code
}

cstrm() {
  local streamUrl
  streamUrl=$(hltv) || return $?
  if ! [[ -z "$streamUrl" ]]; then
    strm $streamUrl
  fi
}


kuse() { erropts
  local contexts; contexts=$(kubectl config get-contexts -o name)
  local context; context=$(<<< "$contexts" fzf)
  kubectl config use-context "$context"
}

kns() { erropts
  local namespaces; namespaces=$(kubectl get namespace)
  local namespace; namespace=$(<<< "$namespaces" tail +2 | fzf | awk '{print $1}')
  kubectl config set-context --current --namespace="$namespace" \
    && kubectl config view -o=json \
    | jq '. as $root | .contexts[] | select(.name == $root["current-context"]) | "Cluster:   " + .context.cluster +  "\nNamespace: " + .context.namespace' -r
}

kset() {
  kuse
  kns
}

kls-deployment-pods() {
  test $# -eq 0 && {
    echo "Missing deployment name" && kubectl get deployments
    return 1
  }
  deployment="$1"; shift
  replicaSet="$(kubectl describe deployment $deployment \
    | grep '^NewReplicaSet' \
    | awk '{print $2}'
  )"

  podHashLabel="$(kubectl get rs $replicaSet \
    -o jsonpath='{.metadata.labels.pod-template-hash}'
  )"

  kubectl get pods -l pod-template-hash=$podHashLabel --show-labels \
    | tail -n +2 | awk '{print $1}'
}

k9() {
  if [[ "${1-}" =~ "^-.*$" ]] || \
     [[ "${1-}" =~ "completion|help|info|version" ]]; then
    env k9s $*
  else
    env k9s -c $*
  fi
}

date-utc() {
  date --iso-8601=seconds --utc $@ | sed 's/\+[[:digit:]][[:digit:]]\:[[:digit:]][[:digit:]]/Z/g'
}

promptout() {
  local readtmpvar=""
  printf "%s\n" "$1" >&2
  read -s readtmpvar
  printf "%s" "$readtmpvar"
}

vhich() {
  "$EDITOR" "$(which $1)"
}
