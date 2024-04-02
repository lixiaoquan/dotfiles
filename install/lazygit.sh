#!/bin/bash

set -e

# Install lazygit
cd
rm -rf lazygit
tar zxvf $HOME/packages/lazygit_0.41.0_Linux_x86_64.tar.gz lazygit
mkdir -p $HOME/local
mkdir -p $HOME/local/bin
mv lazygit $HOME/local/bin
# Install lazygit end

