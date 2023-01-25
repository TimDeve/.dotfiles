#!/usr/bin/env bash
set -Eeuo pipefail

mkdir -p ~/.config/nvim/undo

if [ -r ~/.config/nvim/init.vim ]; then
  mv ~/.config/nvim/init.vim ~/.config/nvim/init.vim.bak
fi

if [ -r ~/.config/nvim/init.lua ]; then
  mv ~/.config/nvim/init.lua ~/.config/nvim/init.lua.bak
fi

LEVEL=${1-"full"}

if [ "$LEVEL" = "bare" ]; then
  ln -s ~/.dotfiles/nvim/bare.vim ~/.config/nvim/init.vim
elif [ "$LEVEL" = "full" ]; then
  ln -s ~/.dotfiles/nvim/init.lua ~/.config/nvim/init.lua
fi

