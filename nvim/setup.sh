#!/bin/bash

mkdir -p ~/.config/nvim
mkdir ~/.config/nvim/undo
mkdir ~/.config/nvim/autoload
mv ~/.config/nvim/init.vim ~/.config/nvim/init.vim.bak 
ln -s ~/.dotfiles/nvim/nvimrc ~/.config/nvim/init.vim
curl -fLo ~/.config/nvim/autoload/plug.vim \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
