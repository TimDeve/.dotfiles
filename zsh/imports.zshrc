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

if uname -a | egrep '[Mm]icrosoft' 1>/dev/null 2>/dev/null; then
  PATH="$PATH:$HOME/.dotfiles/scripts/wsl"
fi

source ~/.dotfiles/zsh/localpost.zshrc

# Cleanup uname variable
unset -v uname
