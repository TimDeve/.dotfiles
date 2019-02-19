# nvim as editor
export EDITOR="nvim"

# import fzf (fuzzy file finder)
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Add script folder to path
PATH="$HOME/.dotfiles/scripts/general:${PATH}"

# Add home bin to path
PATH="${PATH}:$HOME/bin"

# Add cargo to path
PATH="${PATH}:$HOME/.cargo/bin"

# Add yarn to path
PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# Golang paths
export GOPATH="$HOME/dev/go"
PATH="${PATH}:$GOPATH/bin"

# Deactivate dotnet telemetry
export DOTNET_CLI_TELEMETRY_OPTOUT=1

# Deactivate brew telemetry
export HOMEBREW_NO_ANALYTICS=1

# Allow to exit vi input mode with kj
bindkey -M viins 'kj' vi-cmd-mode
