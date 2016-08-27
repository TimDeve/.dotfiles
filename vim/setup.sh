#!/bin/bash

mkdir -p ~/.vim/bundle
ln -s ~/.dotfiles/vim/vimrc ~/.vimrc
mkdir -p ~/.vim/bundle
git clone https://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim
