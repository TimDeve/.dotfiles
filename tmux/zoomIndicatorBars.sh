#!/bin/bash
if tmux list-panes -F '#F' | grep -q Z;
then
  echo '#[fg=colour0]#[bg=colour1]'
else
  echo '#[bg=colour239]'
fi
