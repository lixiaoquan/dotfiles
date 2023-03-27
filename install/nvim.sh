#!/bin/bash

set -e

# Install nvim
cd

if [[ "$OSTYPE" == "darwin"* ]]; then
  rm -rf nvim-osx64
  tar zxvf $HOME/packages/nvim-macos.tar.gz
else
  rm -rf $HOME/local/bin/nvim
  cp $HOME/packages/nvim.appimage $HOME/local/bin/nvim
  chmod a+x $HOME/local/bin/nvim
fi
# Install nvim end

