# Mkdir and cd
mkcd() { mkdir -p "$@" && cd "$_"; }

sdb() { mkcd "$HOME/dev/sandbox/$1" }

# cd & ls
cl() { cd "$@" && ls; }

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

function gi() { curl -L -s "https://www.gitignore.io/api/$@" }

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
  if yorn "Delete latest commit?"; then
    git reset HEAD~ --hard
  fi
}

if [[ -f $(which delta) ]]; then
  gdifs() {
    git --no-pager diff | delta --paging=never --keep-plus-minus-markers
    printf '─%.0s' {1..$COLUMNS}
    printf '─%.0s' {1..$COLUMNS}
    git status
  }
else
  gdifs() {
    git --no-pager diff --color
    printf '─%.0s' {1..$COLUMNS}
    printf '─%.0s' {1..$COLUMNS}
    git status
  }
fi

gclonorg() {
  local org=$1 tfa=$2 
  while read -r repo
    do git clone $repo
  done <<< $(curl -H "X-GitHub-OTP: $tfa" -u timdeve -s "https://api.github.com/orgs/$org/repos?per_page=200" | jq -r ".[].ssh_url")
}

gpushf() {
  git push --set-upstream origin $(git rev-parse --abbrev-ref HEAD)
}

gfindcom() {
  git log  | rg "$*" -C 3
}

gcomsincet() {
  git log $1..HEAD --oneline
}

grebai() {
  git rebase -i $(git log --pretty=oneline --color=always | fzf --ansi | cut -d ' ' -f1)
}

n() {
  local lastDir=${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd

  nnn "$@"

  if [ -f $lastDir ]; then
    . $lastDir
    rm -f $lastDir
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
  local question="$1" answer

  echo "$question (y/N)"

  read -sk answer
  if [ $answer = y ]; then
    return 0
  else
    return 1
  fi
}

nprl() {
  jq .scripts < $(git rev-parse --show-toplevel)/package.json
}

poll() {
  local sleepTime=$1

  shift

  while true; do
    eval $@
    sleep $sleepTime
  done
}

# Nix
nxf() {
  nix-env -qaP ".*$@.*"
}

tmuxa() {
  tmux attach-session -t $@ || tmux new-session -s $@
}

carpw() {
  npx nodemon -e carp,h -x "carp -x $@ || exit 1"
}

carpwc() {
  npx nodemon -e carp,h -x "carp --check $@ || exit 1"
}

carpwb() {
  npx nodemon -e carp,h -x "carp -b $@ || exit 1"
}

carpwsan() {
  npx nodemon -e carp,h -x "carp -x --log-memory --eval-preload '(Debug.sanitize-addresses)' $@ || exit 1"
}

newsh() {
  echo "#!/usr/bin/env bash\nset -Eeuo pipefail\n" > $1 && chmod +x $1
}

newshf() {
  cp ~/.dotfiles/template/bash.sh $1 && chmod +x $1
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
  ffmpeg -i "$1" -vf "fps=10,scale=320:-1:flags=lanczos" -c:v pam -f image2pipe - | convert -delay 10 - -loop 0 -layers optimize "$2"
}

