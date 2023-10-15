#!/usr/bin/env bash

mv ~/.tmux.conf ~/.tmux.conf.bak
ln -s ~/.dotfiles/tmux/tmp.tmux ~/.tmux.conf
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
