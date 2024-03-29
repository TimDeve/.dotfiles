# nvim as editor
export EDITOR="nvim"

export SD_ROOT="$HOME/.dotfiles/scripts/sd"

# import fzf (fuzzy file finder)
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='rg --files --hidden'

# Add script folder to path
PATH="$HOME/.dotfiles/scripts/general:${PATH}"

# Add home bin to path
PATH="${PATH}:$HOME/bin"
PATH="${PATH}:$HOME/.local/bin"

# Add cargo to path
PATH="${PATH}:$HOME/.cargo/bin"

# Add yarn to path
PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

[ -f "$HOME/.ghcup/env" ] && source "$HOME/.ghcup/env" # ghcup-env

# Golang paths
if [[ -z "$GOPATH" ]]; then
  export GOPATH="$HOME/dev/go"
fi

for gpath in "${(@s/:/)GOPATH}"; do
  PATH="$PATH:${gpath}/bin"
done

# Deactivate dotnet telemetry
export DOTNET_CLI_TELEMETRY_OPTOUT=1

# Allow to exit vi input mode with kj
bindkey -M viins 'kj' vi-cmd-mode

export BAT_THEME="base16"

