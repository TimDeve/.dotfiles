xbs() {
  local search_term
  search_term="$@"
  if [[ -z "$search_term" ]]; then
    search_term='*'
  fi

  xbps-query -Rs "$search_term" \
    | awk '{ $3="- " $3 }1' \
    | fzf -m --preview 'xbps-query -R {2}' \
    | awk '{ print $2 }' \
    | xargs -ro sudo xbps-install -S
}

xbr() {
  if [[ -z "$@" ]]; then
    xbps-query -l \
      | awk '{sub($1 OFS, ""); $2="- " $2}1' \
      | fzf -m --preview 'xbps-query -R {1}' \
      | awk '{ print $1 }' \
      | xargs -ro sudo xbps-remove -R
  else
    sudo xbps-remove -R "$@"
  fi
}

whichwin() {
  local winpath
  winpath=$(powershell.exe -Command "Get-Command $@ | Select-Object -First 1 | foreach { \$_.Source }")
  wslpath $winpath
}

nxs() {
  local packages blue reset
  if [ -t 1 ]; then
    blue="\\\\x1b[34m"
    reset="\\\\x1b[39m"
  fi

  packages=$(nix --experimental-features 'nix-command flakes' search nixpkgs "$@" --json \
    | jq "to_entries[]
          | .value
          | \"$blue\\(.pname)$reset | \\(.version) | \\(.description)\"" -r)

  if hash tput && [[ "$(tput cols)" -ge 200 ]];  then
    echo "$packages" | column -t -s "|"
  else
    echo "$packages"
  fi
}
