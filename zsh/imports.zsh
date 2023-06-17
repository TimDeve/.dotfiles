uname=$(uname)
uname=${uname:0:6}

# Import General Stuff
source ~/.dotfiles/zsh/general.all.zsh

case $uname in
  "Darwin"*)
    source ~/.dotfiles/zsh/general.osx.zsh
    ;;
  "Linux"*)
    source ~/.dotfiles/zsh/general.linux.zsh
    ;;
  "CYGWIN"*)
    source ~/.dotfiles/zsh/general.cygwin.zsh
    ;;
esac

# Import Alias
source ~/.dotfiles/zsh/alias.all.zsh

case $uname in
  "Darwin"*)
    source ~/.dotfiles/zsh/alias.osx.zsh
    ;;
  "Linux"*)
    source ~/.dotfiles/zsh/alias.linux.zsh
    ;;
  "CYGWIN"*)
    source ~/.dotfiles/zsh/alias.cygwin.zsh
    ;;
esac

# Import Functions
source ~/.dotfiles/zsh/functions.all.zsh

case $uname in
  "Darwin"*)
    source ~/.dotfiles/zsh/functions.osx.zsh
    ;;
  "Linux"*)
    source ~/.dotfiles/zsh/functions.linux.zsh
    ;;
  "CYGWIN"*)
    source ~/.dotfiles/zsh/functions.cygwin.zsh
    ;;
esac

if uname -a | egrep '[Mm]icrosoft' 1>/dev/null 2>/dev/null; then
  PATH="$PATH:$HOME/.dotfiles/scripts/wsl"
fi

source ~/.dotfiles/zsh/localpost.zsh

# Cleanup uname variable
unset -v uname
