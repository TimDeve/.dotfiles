#!/usr/bin/env bash
set -Eeuo pipefail

prezto_setup() {
  mv ~/.zshrc ~/.zshrc.bak
  ln -s $DOTFILES/zsh/zshrc.prezto ~/.zshrc
  touch $DOTFILES/zsh/localpre.zsh
  touch $DOTFILES/zsh/localpost.zsh
  git -C ~/.zprezto pull || git clone --recursive https://github.com/sorin-ionescu/prezto.git ~/.zprezto
  mkdir -p ~/.zgen
  git -C ~/.zgen/zgen pull || git clone https://github.com/tarjoilija/zgen ~/.zgen/zgen
  zsh -ilc "zgen reset"
}

zgen_setup() {
  mv ~/.zshrc ~/.zshrc.bak
  ln -s $DOTFILES/zsh/zshrc.zgen ~/.zshrc
  touch $DOTFILES/zsh/localpre.zsh
  touch $DOTFILES/zsh/localpost.zsh
  mkdir -p ~/.zgen
  git -C ~/.zgen/zgen pull || git clone https://github.com/tarjoilija/zgen ~/.zgen/zgen
  zsh -ilc "zgen reset"
}

target=${1-}

if [[ -z "$target" ]]; then
  target=zgen
fi

"${target}_setup"
