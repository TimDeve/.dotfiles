#!/bin/bash


### Packets to install
toInstall=('neovim'\
  'rtv'\
  'livestreamer'\
)

for i in "${toInstall[@]}"
do
  sudo pip install $i
  echo ""
done
