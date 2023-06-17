alias ya="yaourt"

alias vmshrink="sudo vmware-toolbox-cmd disk shrink"

alias apt="sudo apt"

alias timesync="sudo systemctl restart systemd-timesyncd.service"

# xbps
alias xbi="sudo xbps-install -S"
alias xbu="sudo xbps-install -Su"

# Nix
alias nxe="nix-env"
alias nxi="nix-env -i"
alias nxr="nix-env -e"
alias nxu="nix-channel --update && nix-env -u"
alias nxgc="nix-collect-garbage --delete-older-than 31d"
