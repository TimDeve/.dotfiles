#!/usr/bin/env bash
set -Eeuo pipefail

mkdir -p ~/.config/nvim/undo
mkdir -p ~/.config/nvim/autoload

if [ -r ~/.config/nvim/init.vim ]; then
  mv ~/.config/nvim/init.vim ~/.config/nvim/init.vim.bak
fi

LEVEL=${1-"full"}

if [ "$LEVEL" = "bare" ]; then
  ln -s ~/.dotfiles/nvim/bare.nvimrc ~/.config/nvim/init.vim
elif [ "$LEVEL" = "light" ]; then
  ln -s ~/.dotfiles/nvim/light.nvimrc ~/.config/nvim/init.vim
  curl -fLo ~/.config/nvim/autoload/plug.vim \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
elif [ "$LEVEL" = "full" ]; then
  ln -s ~/.dotfiles/nvim/nvimrc ~/.config/nvim/init.vim
  curl -fLo ~/.config/nvim/autoload/plug.vim \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

