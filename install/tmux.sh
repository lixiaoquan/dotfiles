#!/bin/bash

set -e

sudo apt install libevent-dev libncurses5-dev

# Install vim
mkdir -p build_package
cd build_package
tar zxvf $HOME/packages/tmux-3.2a.tar.gz
cd tmux-3.2a
./configure --prefix=$HOME/local
make -j8
make install
cd
# Install vim end

