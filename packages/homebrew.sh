#!/bin/bash

### Packages to install
toInstall=(\
  'ack'\
  'coreutils'\
  'curl'\
  'fasd'\
  'ffmpeg'\
  'findutils'\
  'git'\
  'htop'\
  'imagemagick'\
  'mas'\
  'md5sha1sum'\
  'mobile-shell'\
  'moreutils'\
  'neovim'\
  'nmap'\
  'node'\
  'openssh'\
  'python'\
  'python3'\
  'ranger'\
  'rsync'\
  'ruby'\
  'speedtest_cli'\
  'the_silver_surfer'\
  'tig'\
  'tmux'\
  'vim'\
  'weechat'\
  'wget'\
  'zsh'\
)

for i in "${toInstall[@]}"
do
  brew install $i

  echo ""
  echo "---------"
  echo ""
done

unset toInstall

