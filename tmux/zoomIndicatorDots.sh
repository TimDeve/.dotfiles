#!/bin/bash
if tmux list-panes -F '#F' | grep -q Z;
then
  echo '#[fg=colour4]'
else
  echo '#[fg=colour2]'
fi
