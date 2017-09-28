#!/bin/bash

### Packages to install
toInstall=(\
  'livestreamer'\
  'neovim'\
  'rtv'\
)

for i in "${toInstall[@]}"
do
  sudo pip install $i

  echo ""
  echo "---------"
  echo ""
done

unset toInstall

