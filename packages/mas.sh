#!/bin/bash

### Packages to install
toInstall=(\
  # Amphetamine
  '937984704'\
)

for i in "${toInstall[@]}"
do
  mas install $i

  echo ""
  echo "---------"
  echo ""
done

unset toInstall

