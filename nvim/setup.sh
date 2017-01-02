#!/bin/bash

mkdir -p ~/.config/nvim
mkdir ~/.config/nvim/undo
mkdir ~/.config/nvim/autoload
mv ~/.dotfiles/nvim/nvimrc ~/.dotfiles/nvim/nvimrc.bak
ln -s ~/.dotfiles/nvim/nvimrc ~/.config/nvim/init.vim
curl -fLo ~/.config/nvim/autoload/plug.vim \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
