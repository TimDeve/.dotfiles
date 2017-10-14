#!/bin/bash

### Packages to install
toInstall=(
  'alfred'
  'google-chrome'
  'google-play-music-desktop-player'
  'iterm2'
  'opera'
  'spectacle'
  'torbrowser'
  'transmission'
  'visual-studio-code'
)

for i in "${toInstall[@]}"
do
  brew cask install $i

  echo ""
  echo "---------"
  echo ""
done

unset toInstall

