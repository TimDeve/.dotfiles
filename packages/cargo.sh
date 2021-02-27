#!/bin/bash

### Packages to install
toInstall=(
  'git-delta'
  'cargo-edit'
  'cargo-watch'
  'cargo-update'
  'ht'
)

for i in "${toInstall[@]}"
do
  cargo install $i

  echo ""
  echo "---------"
  echo ""
done

unset toInstall

