#!/bin/bash

set -e

# Install nvim
cd

if [[ "$OSTYPE" == "darwin"* ]]; then
  rm -rf nvim-osx64
  tar zxvf $HOME/packages/nvim-macos.tar.gz
else
  arch=$(uname -m)
  rm -rf $HOME/${arch}_local/bin/nvim
  mkdir -p $HOME/${arch}_local/bin
  cp $HOME/packages/nvim-v0.8.3.aarch64.appimage $HOME/${arch}_local/bin/nvim
  chmod a+x $HOME/${arch}_local/bin/nvim
fi
# Install nvim end

