#!/bin/bash

### Packages to install
toInstall=(
  'create-react-app'
  'create-react-native-app'
  'eslint'
  'node-host'
  'parinfer'
  'peerflix'
  'prettier'
  'react-native-cli'
  'trash-cli'
  'typescript'
  'webpack'
  'yarn'
  'youtube-dl'
)

for i in "${toInstall[@]}"
do
  npm install -g $i

  echo ""
  echo "---------"
  echo ""
done

unset toInstall

