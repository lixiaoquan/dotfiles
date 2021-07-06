#!/bin/bash

set -e

sudo apt install libevent-dev

# Install vim
mkdir -p build_package
cd build_package
tar zxvf $HOME/packages/tmux-2.6.tar.gz
cd tmux-2.6
./configure --prefix=$HOME/local
make -j8
make install
cd
# Install vim end

