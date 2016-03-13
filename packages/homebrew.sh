#!/bin/bash


### Packets to install
toInstall=('zsh'\
  'tmux'\
  'ranger'\
  'nvim'\
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
  'htop'\
  'imagemagick'\
  'mas'\
  'md5sha1sum'\
  'mobile-shell'\
  'nmap'\
  'pastebinit'\
  'node'\
  'python'\
  'python3'\
  'ruby'\
  'rsync'\
  'speedtest_cli'\
  'tig'\
  'irssi'\
  'weechat'\
  'vim'\
  'git'\
)

for i in "${toInstall[@]}"
do
  brew install $i
  echo ""
done
