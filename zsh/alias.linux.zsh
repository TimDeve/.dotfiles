alias ya="yaourt"

alias vmshrink="sudo vmware-toolbox-cmd disk shrink"

alias apt="sudo apt"

alias timesync="sudo systemctl restart systemd-timesyncd.service"

# xbps
alias xbi="sudo xbps-install -S"
alias xbu="sudo xbps-install -Su"

# Nix
alias nix-install-home-flake="nix profile install $NIX_HOME_FLAKE"

if hash paru 1>&2 2>/dev/null; then
  alias pmi="paru --mode=r -S"
  alias pmr="paru -Rs"
  alias pmu="paru -Syu"

  pms() { erropts
    local state_file; state_file="$(mktemp PMSTMP.XXXXXXXXXX -p /tmp)"
    trap "rm $state_file" EXIT

    package=$(paru --repo -Sl | fzf --nth 2 \
      --preview '<<< "{}" awk "{print \$2}" | xargs paru -Si' \
      --bind "ctrl-f:reload(
          if [[ \"\$(cat $state_file)\" == aur ]]; then
            echo 'repo' >! $state_file;
            paru --repo -Sl
          else
            echo 'aur' >! $state_file;
            paru --aur -Sl
          fi
        )" \
     --bind "ctrl-r:reload(
          if [[ \"\$(cat $state_file)\" == aur ]]; then
            paru --aur -Sly
          else
            paru --repo -Sly
          fi
        )" \
      )

    paru -S "$(<<< "$package" awk '{print $2}')"
  }
fi
