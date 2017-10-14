#!/bin/bash

### Packages to install
toInstall=(
  'diff-highlight'
  'livestreamer'
  'neovim'
  'rtv'
)

for i in "${toInstall[@]}"
do
  sudo pip3 install $i

  echo ""
  echo "---------"
  echo ""
done

unset toInstall

