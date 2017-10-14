#!/bin/bash

### Packages to install
toInstall=(
  'ack'
  'bash'
  'coreutils'
  'curl'
  'diff-so-fancy'
  'fasd'
  'ffmpeg'
  'findutils'
  'gawk'
  'git'
  'htop'
  'imagemagick'
  'mas'
  'md5sha1sum'
  'mobile-shell'
  'moreutils'
  'neovim'
  'nmap'
  'node'
  'openssh'
  'python'
  'python3'
  'ranger'
  'rsync'
  'ruby'
  'speedtest_cli'
  'the_silver_searcher'
  'tig'
  'tmux'
  'vim'
  'weechat'
  'wget'
  'zsh'
)

for package in ${toInstall[@]}
do
  brew install $package

  echo ""
  echo "---------"
  echo ""
done

unset toInstall

