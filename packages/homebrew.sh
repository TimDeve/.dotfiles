#!/bin/bash


### Packets to install
toInstall=('zsh'\
  'coreutils'\
  'moreutils'\
  'findutils'\
  'wget'\
  'curl'\
  'openssh'\
  'ack'\
  'the_silver_surfer'\
  'brew-cask'\
  'cheat'\
  'duck'\
  'fasd'\
  'ffmpeg'\
  'htop-osx'\
  'imagemagick'\
  'mas'\
  'md5sha1sum'\
  'ranger'\
  'mobile-shell'\
  'vim'\
  'nmap'\
  'pastebinit'\
  'node'\
  'python'\
  'python3'\
  'rsync'\
  'speedtest_cli'\
  'git'\
  'tig'\
  'tmux'\
  'irssi'\
  'weechat'\
)

for i in "${toInstall[@]}"
do
  brew install $i
  echo ""
done
