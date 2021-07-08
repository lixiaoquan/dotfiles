#!/bin/bash

read -p "Are you sure to remove current ~/.fzf and ~/.fzf.bash ? " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
  rm -rf ~/.fzf
  rm -f ~/.fzf.bash

  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install
fi


