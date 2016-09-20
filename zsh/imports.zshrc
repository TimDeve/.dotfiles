uname=$(uname)
uname=${uname:0:6}

# Import General Stuff
source ~/.dotfiles/zsh/general.all.zshrc

case $uname in
  "Darwin"*)
    source ~/.dotfiles/zsh/general.osx.zshrc
    ;;
  "Linux"*)
    source ~/.dotfiles/zsh/general.linux.zshrc
    ;;
  "CYGWIN"*)
    source ~/.dotfiles/zsh/general.cygwin.zshrc
    ;;
esac

# Import Alias
source ~/.dotfiles/zsh/alias.all.zshrc

case $uname in
  "Darwin"*)
    source ~/.dotfiles/zsh/alias.osx.zshrc
    ;;
  "Linux"*)
    source ~/.dotfiles/zsh/alias.linux.zshrc
    ;;
  "CYGWIN"*)
    source ~/.dotfiles/zsh/alias.cygwin.zshrc
    ;;
esac

# Import Functions
source ~/.dotfiles/zsh/functions.all.zshrc

case $uname in
  "Darwin"*)
    source ~/.dotfiles/zsh/functions.osx.zshrc
    ;;
  "Linux"*)
    source ~/.dotfiles/zsh/functions.linux.zshrc
    ;;
  "CYGWIN"*)
    source ~/.dotfiles/zsh/functions.cygwin.zshrc
    ;;
esac

source ~/.dotfiles/zsh/secrets.zshrc

# Cleanup uname variable
unset -v uname
