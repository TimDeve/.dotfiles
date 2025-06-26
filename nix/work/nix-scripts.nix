nixpkgs: with nixpkgs; [
  # Nix upgrade
  (writeScriptBin "nxu" ''
    #!${pkgs.stdenv.shell}
    set -CEeuo pipefail

    # Upgrade inputs (remote repo)
    nix flake update --flake ~/.dotfiles/nix/work

    # Apply nix config
    nix profile upgrade nix/work
  '')

  # Nix Garbage Collect
  (writeScriptBin "nxgc" ''
    #!${pkgs.stdenv.shell}
    nix-collect-garbage --delete-older-than 31d
  '')

  # Nix Install
  (writeShellApplication {
    name = "nxi";
    runtimeInputs = [ nixfmt-rfc-style ];
    text = ''
      pkg_location="$HOME/.dotfiles/nix/work/pkgs.nix"
      new_pkg="$1"
      tail +2 "$pkg_location" |
        head -n -1 |
        awk '{print $1}' |
        cat - <(echo "$new_pkg") |
        sort |
        cat <(echo "nixpkgs: with nixpkgs; [") - <(echo "]") |
        nixfmt |
        sponge "$pkg_location"
      if ! nix profile upgrade nix/work; then
        sed -i "/\\s*$new_pkg$/d" "$pkg_location"
        return 1
      fi
    '';
  })

  # Nix Search
  (writeShellApplication {
    name = "nxs";
    runtimeInputs = [ nix-search-cli ];
    text = ''
      blue="" reset=""
      if [ -t 1 ]; then
        blue="\\\\x1b[34m"
         reset="\\\\x1b[39m"
      fi

      packages=$(nix-search --max-results 31 --json "$@"  \
          | jq "\"$blue\\(.package_attr_name)$reset | \\(.package_pversion) | \\(.package_description) | \\(.package_programs | .[0:3] | join(\", \"))\"" -r)

      if hash tput && [[ "$(tput cols)" -ge 200 ]];  then
        echo -e "$packages" | head -n -1 | column -t -s "|"
        if [[ $(<<< "$packages" wc -l) == 31 ]]; then
          echo "[...]" 1>&2
        fi
      else
        echo -e "$packages" | head -n -1
      fi
    '';
  })
]
