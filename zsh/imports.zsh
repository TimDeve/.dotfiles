uname=$(uname)
uname=${uname:0:6}

SCRIPT_PATH="${0:A:h}"
export DOTFILES=$(dirname $SCRIPT_PATH)

# Import General Stuff
source $DOTFILES/zsh/general.all.zsh

case $uname in
  "Darwin"*)
    source $DOTFILES/zsh/general.osx.zsh
    ;;
  "Linux"*)
    source $DOTFILES/zsh/general.linux.zsh
    ;;
  "CYGWIN"*)
    source $DOTFILES/zsh/general.cygwin.zsh
    ;;
esac

# Import Alias
source $DOTFILES/zsh/alias.all.zsh

case $uname in
  "Darwin"*)
    source $DOTFILES/zsh/alias.osx.zsh
    ;;
  "Linux"*)
    source $DOTFILES/zsh/alias.linux.zsh
    ;;
  "CYGWIN"*)
    source $DOTFILES/zsh/alias.cygwin.zsh
    ;;
esac

# Import Functions
source $DOTFILES/zsh/functions.all.zsh

case $uname in
  "Darwin"*)
    source $DOTFILES/zsh/functions.osx.zsh
    ;;
  "Linux"*)
    source $DOTFILES/zsh/functions.linux.zsh
    ;;
  "CYGWIN"*)
    source $DOTFILES/zsh/functions.cygwin.zsh
    ;;
esac

if uname -a | egrep '[Mm]icrosoft' 1>/dev/null 2>/dev/null; then
  PATH="$PATH:$HOME/.dotfiles/scripts/wsl"
fi

source $DOTFILES/zsh/localpost.zsh

# Cleanup uname variable
unset -v uname
