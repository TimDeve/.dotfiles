#!/usr/bin/env bash
set -Eeuo pipefail

prezto_setup() {
  mv ~/.zshrc ~/.zshrc.bak
  ln -s ~/.dotfiles/zsh/zshrc.prezto ~/.zshrc
  touch ~/.dotfiles/zsh/localpre.zshrc
  touch ~/.dotfiles/zsh/localpost.zshrc
  git -C ~/.zprezto pull || git clone --recursive https://github.com/sorin-ionescu/prezto.git ~/.zprezto
  mkdir -p ~/.zgen
  git -C ~/.zgen/zgen pull || git clone https://github.com/tarjoilija/zgen ~/.zgen/zgen
  zsh -ilc "zgen reset"
}

zgen_setup() {
  mv ~/.zshrc ~/.zshrc.bak
  ln -s ~/.dotfiles/zsh/zshrc.zgen ~/.zshrc
  touch ~/.dotfiles/zsh/localpre.zshrc
  touch ~/.dotfiles/zsh/localpost.zshrc
  mkdir -p ~/.zgen
  git -C ~/.zgen/zgen pull || git clone https://github.com/tarjoilija/zgen ~/.zgen/zgen
  zsh -ilc "zgen reset"
}


target=${1-}

if [[ -z "$target" ]]; then
  target=zgen
fi

"${target}_setup"
