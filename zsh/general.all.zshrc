# nvim as editor
export EDITOR="nvim"

# import fzf (fuzzy file finder)
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Add script folder to path
PATH="$HOME/.dotfiles/scripts/general:${PATH}"

# Add home bin to path
PATH="$HOME/bin:${PATH}"
