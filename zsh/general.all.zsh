# nvim as editor
export EDITOR="nvim"

export SD_ROOT="$DOTFILES/scripts/sd"

source-if-exists() { [[ -f "$1" ]] && source "$1"; }

source-if-exists "$HOME/.ghcup/env"
source-if-exists "$HOME/.cargo/env"
source-if-exists "$HOME/.nix-profile/etc/profile.d/nix.sh"
source-if-exists "$HOME/.fzf.zsh"

if hash rg &>/dev/null; then
  export FZF_DEFAULT_COMMAND='rg --files --hidden'
fi

# Add script folder to path
PATH="$HOME/.dotfiles/scripts/general:${PATH}"

# Add home bin to path
PATH="$HOME/bin:$PATH"
PATH="$HOME/.local/bin:$PATH"

# Golang paths
if [[ -z "$GOPATH" ]]; then
  export GOPATH="$HOME/dev/go"
fi

for gpath in "${(@s/:/)GOPATH}"; do
  PATH="$PATH:${gpath}/bin"
done

# Deactivate dotnet telemetry
export DOTNET_CLI_TELEMETRY_OPTOUT=1

export BAT_THEME="base16"

# Don't overwrite files on redirect
setopt noclobber

