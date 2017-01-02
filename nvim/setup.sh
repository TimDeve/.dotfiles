#!/bin/bash

mkdir -p ~/.config/nvim
ln -s ~/.dotfiles/nvim/nvimrc ~/.config/nvim/init.vim
 ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
mkdir -p ~/.config/nvim/bundle
