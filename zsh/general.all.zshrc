# nvim as editor
export EDITOR="nvim"

# import fzf (fuzzy file finder)
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Add script folder to path
PATH="$HOME/.dotfiles/scripts/general:${PATH}"

# Add home bin to path
PATH="$HOME/bin:${PATH}"

# Add cargo to path
PATH="$HOME/.cargo/bin:${PATH}"

# Golang paths
export GOPATH="$HOME/dev/go"
PATH="${PATH}:$GOPATH/bin"

# Deactivate dotnet telemetry
export DOTNET_CLI_TELEMETRY_OPTOUT=1
