#!/bin/bash

set -e

# Install vim
mkdir -p build_package
cd build_package
tar zxvf $HOME/packages/vim-8.2.tar.bz2
cd vim82
./configure --prefix=$HOME/local
make -j8
make install
cd
# Install vim end

