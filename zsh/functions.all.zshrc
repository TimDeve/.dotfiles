# Mkdir and cd
mkcd() { mkdir -p "$@" && cd "$_"; }

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
    git stash > /dev/null 2>&1 && git stash drop > /dev/null 2>&1
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

gdifs() {
  git diff --color
  printf '─%.0s' {1..$COLUMNS}
  printf '─%.0s' {1..$COLUMNS}
  git status
}

gclonorg() {
  local org=$1 tfa=$2 
  while read -r repo
    do git clone $repo
  done <<< $(curl -H "X-GitHub-OTP: $tfa" -u timdeve -s "https://api.github.com/orgs/$org/repos?per_page=200" | jq -r ".[].ssh_url")
}

gpushf() {
  git push --set-upstream origin $(git rev-parse --abbrev-ref HEAD)
}

n() {
  nnn "$@"

  if [ -f "/tmp/nnn" ]; then
    . "/tmp/nnn"
    rm -f "/tmp/nnn"
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
