#!/bin/bash

### Packages to install
toInstall=(
  'create-react-app'
  'create-react-native-app'
  'eslint'
  'javascript-typescript-langserver'
  'node-host'
  'peerflix'
  'pnpm'
  'prettier'
  'react-native-cli'
  'trash-cli'
  'typescript'
  'typescript-language-server'
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

