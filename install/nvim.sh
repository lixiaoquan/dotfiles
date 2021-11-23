#!/bin/bash

set -e

# Install nvim
cd

if [[ "$OSTYPE" == "darwin"* ]]; then
  rm -rf nvim-osx64
  tar zxvf $HOME/packages/nvim-macos.tar.gz
else
  rm -rf nvim-linux64
  tar zxvf $HOME/packages/nvim-linux64.tar.gz nvim-linux64
fi
# Install nvim end

