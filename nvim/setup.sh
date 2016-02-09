#!/bin/bash

mkdir -p ~/.config/nvim
ln -s ~/.dotfiles/nvim/nvimrc ~/.config/nvim/init.vim
mkdir -p ~/.config/nvim/bundle
git clone https://github.com/Shougo/neobundle.vim ~/.config/nvim/bundle/neobundle.vim
