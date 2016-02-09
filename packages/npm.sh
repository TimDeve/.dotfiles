#!/bin/bash


### Packets to install
toInstall=(\
  'bower'\
  'bower-installer'\
  'caniuse-cmd'\
  'grunt-cli'\
  'gulp'\
  'peerflix'\
  'youtube-dl'\
)

for i in "${toInstall[@]}"
do
  npm install -g $i
  echo ""
done
